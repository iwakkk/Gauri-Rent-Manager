//
//  NewOrderViewModel.swift
//  RentManager
//
//  Created by Edward Suwandi on 19/02/26.
//

import Foundation

@Observable
class NewOrderViewModel {
    
    var parsedDraft: OrderDraft?
    var allProducts: [Products] = []
    var isLoading = false
    
    // Month map (Change Month Format from String to Int)
    private let monthMap: [String: Int] = [
        // Indonesian
        "januari": 1, "jan": 1,
        "februari": 2, "feb": 2,
        "maret": 3, "mar": 3,
        "april": 4, "apr": 4,
        "mei": 5,
        "juni": 6, "jun": 6,
        "juli": 7, "jul": 7,
        "agustus": 8, "agu": 8,
        "september": 9, "sep": 9,
        "oktober": 10, "okt": 10,
        "november": 11, "nov": 11,
        "desember": 12, "des": 12,
        
        // English
        "january": 1,
        "february": 2,
        "march": 3,
        "may": 5,
        "june": 6,
        "july": 7,
        "august": 8, "aug": 8,
        "october": 10, "oct": 10,
        "december": 12, "dec": 12
    ]
    
    // Func to normalize text (Remove unnecessary characters)
    func normalizeText(_ text: String) -> String {
        text
            .lowercased()
            .replacingOccurrences(of: ".", with: "")
            .replacingOccurrences(of: ",", with: "")
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    // Func to parse month to Int using monthmap
    private func parseMonth(_ text: String?) -> Int? {
        guard let text = text?.lowercased() else { return nil }
        return monthMap[text]
    }
    
    // Func to build date (from day, month, year, to day month year)
    private func buildDate(day: Int, month: Int, year: Int) -> Date? {
        var comp = DateComponents()
        comp.day = day
        comp.month = month
        comp.year = year
        return Calendar.current.date(from: comp)
    }
    
    // Func to match inserted products with products in database
    func matchProduct(from text: String, products: [Products]) -> Products? {
        
        // Remove unnecessary characters
        let query = text
            .lowercased()
            .replacingOccurrences(of: "-", with: " ")
            .trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Split Words
        let words = query.components(separatedBy: " ")
        
        // Calculate Score
        let scored = products.map { product -> (Products, Int) in
            
            // Initial Score
            var score = 0
            
            // Normalize product name and color
            let name = product.name.lowercased()
            let color = product.color.lowercased()
            
            for word in words {
                
                // Add score if product name contains the word
                if name.contains(word) { score += 2 }
                
                // Add score if product name contains the color
                if color.contains(word) { score += 3 }
            }
            
            // Return product with score
            return (product, score)
        }
        
        // Sort products from the highest score, and take the first product (best-matched)
        return scored
            .sorted { $0.1 > $1.1 }
            .first?
            // Get the first element of the tupple (Products)
            .0
    }
    
    // Func to extract dates
    func extractDates(from text: String) -> (Date?, Date?) {
        
        // Normalize Text
        let normalizedText = normalizeText(text)
        
        // Get current year
        let year = Calendar.current.component(.year, from: Date())
        
        // Find the line that contains "periode sewa"
        guard let line = normalizedText
            .components(separatedBy: .newlines)
            .first(where: { $0.contains("periode sewa") }) else {
            return (nil, nil)
        }
        
        // Regex pattern to extract :
        // (\d{1,2}) -> day, 1 or 2 digits
        // (?:\s*([a-z]+))? -> text, optional (? in the end)
        // \s*-\s* -> -, can have space or no before and after the -
        let pattern = #"(\d{1,2})(?:\s*([a-z]+))?\s*-\s*(\d{1,2})(?:\s*([a-z]+))?"#
        
        // Create regex object
        guard let regex = try? NSRegularExpression(pattern: pattern) else {
            return (nil, nil)
        }
        
        // Create an NSRange that covers the entire line so the regex can cover the whole text
        let range = NSRange(line.startIndex..., in: line)
        
        
        // Find the first date range that matches the regex pattern
        guard let match = regex.firstMatch(in: line, range: range) else {
            return (nil, nil)
        }
        
        // Helper function to extract regex capture groups, example: 28 May - 1 June, get(1) = 28, get(2) = May, etc
        func get(_ index: Int) -> String? {
            
            // Get the range of the selected regex group
            guard let r = Range(match.range(at: index), in: line) else { return nil }
            
            // Extract text from the range and remove extra spaces
            let val = String(line[r])
                .trimmingCharacters(in: .whitespaces)
            
            // Return nil if extracted value is empty
            return val.isEmpty ? nil : val
        }
        
        // Convert start date and end date to Int
        let startDay = Int(get(1) ?? "") ?? 0
        let endDay = Int(get(3) ?? "") ?? 0
        
        // Convert start month and end month to Int
        let startMonthText = get(2)
        let endMonthText = get(4)
        
        // If start month is missing, use end month, example: 10 - 12 May, then it is 10 May
        let startMonthKey = startMonthText ?? endMonthText
        
        // If end month is missing, use start month, example: 10 May - 12, then it is 12 May
        let endMonthKey = endMonthText ?? startMonthText
        
        // Ensure all required month values exist and can be converted properly
        guard let smKey = startMonthKey,
              let emKey = endMonthKey,
              let startMonth = parseMonth(smKey),
              let endMonth = parseMonth(emKey) else {
            return (nil, nil)
        }
        
        // Create start date and end date from extracted day, month, and year
        let startDate = buildDate(day: startDay, month: startMonth, year: year)
        let endDate = buildDate(day: endDay, month: endMonth, year: year)
        
        return (startDate, endDate)
    }
    
    // Main Parser
    func parseOrderText(_ text: String, products: [Products]) -> OrderDraft {
        
        var draft = OrderDraft()
        var items: [OrderItemDraft] = []
        var currentItem: OrderItemDraft?
        
        // Split full text into seperate lines
        let lines = text.components(separatedBy: .newlines)
        
        // Loop through each line
        for rawLine in lines {
            
            // Clean extra spaces and newline characters
            let line = rawLine.trimmingCharacters(in: .whitespacesAndNewlines)
            guard !line.isEmpty else { continue }
            
            // Split each line into key-value format using ":"
            let parts = line.components(separatedBy: ":")
            
            if parts.count >= 2 {
                
                let key = parts[0].trimmingCharacters(in: .whitespaces)
                let value = parts[1].trimmingCharacters(in: .whitespaces)
                
                // Determine fields
                switch key {
                    
                case "Nama":
                    draft.customerName = value
                    
                case "Alamat":
                    draft.customerAddress = value
                    
                case "No Hp":
                    draft.customerPhone = value
                    
                case "No rekening pengembalian deposit":
                    draft.customerBankAccount = value
                    
                case "Dress":
                    
                    // Save previous item before starting a new one
                    if let item = currentItem {
                        items.append(item)
                    }
                    
                    // Create a new item for this dress
                    var newItem = OrderItemDraft()
                    
                    // Try to match product from database using matchProduct function
                    if let matched = matchProduct(from: value, products: products) {
                        newItem.selectedProduct = matched
                        newItem.productName = matched.name
                        newItem.color = matched.color
                        newItem.price = matched.price
                    }
                    
                    // Set this new item as current item
                    currentItem = newItem
                    
                case "Size":
                    // Assign size to the currently active item
                    currentItem?.size = value
                    
                default:
                    break
                }
            }
        }
        
        // make sure the last item is also saved
        if let item = currentItem {
            items.append(item)
        }
        
        // Assign size to the currently active item
        draft.items = items
        
        // Assign dates using extractDates function
        let (start, end) = extractDates(from: text)
        draft.rentStartDate = start ?? Date()
        draft.rentEndDate = end ?? Date()
        
        return draft
    }
    
    // Load Products
    func loadProducts() async {
        isLoading = true
        do {
            allProducts = try await ProductsService().fetchProducts()
        } catch {
            print("Error fetch products:", error)
        }
        isLoading = false
    }
}
