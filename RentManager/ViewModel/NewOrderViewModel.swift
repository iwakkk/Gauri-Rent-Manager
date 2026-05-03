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
    
    // MONTH MAP
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
    
    // NORMALIZE TEXT
    func normalizeText(_ text: String) -> String {
        text
            .lowercased()
            .replacingOccurrences(of: ".", with: "")
            .replacingOccurrences(of: ",", with: "")
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    // SAFE MONTH PARSER
    private func parseMonth(_ text: String?) -> Int? {
        guard let text = text?.lowercased() else { return nil }
        return monthMap[text]
    }
    
    // DATE BUILDER (SAFE)
    private func buildDate(day: Int, month: Int, year: Int) -> Date? {
        var comp = DateComponents()
        comp.day = day
        comp.month = month
        comp.year = year
        return Calendar.current.date(from: comp)
    }
    
    // PRODUCT MATCH
    func matchProduct(from text: String, products: [Products]) -> Products? {
        let query = text
            .lowercased()
            .replacingOccurrences(of: "-", with: " ")
            .trimmingCharacters(in: .whitespacesAndNewlines)
        
        let words = query.components(separatedBy: " ")
        
        let scored = products.map { product -> (Products, Int) in
            var score = 0
            
            let name = product.name.lowercased()
            let color = product.color.lowercased()
            
            for word in words {
                if name.contains(word) { score += 2 }
                if color.contains(word) { score += 3 }
            }
            
            return (product, score)
        }
        
        return scored
            .sorted { $0.1 > $1.1 }
            .first?
            .0
    }
    
    // DATE EXTRACTION
    func extractDates(from text: String) -> (Date?, Date?) {
        
        let normalizedText = normalizeText(text)
        let year = Calendar.current.component(.year, from: Date())
        
        guard let line = normalizedText
            .components(separatedBy: .newlines)
            .first(where: { $0.contains("periode sewa") }) else {
            return (nil, nil)
        }
        
        let pattern = #"(\d{1,2})(?:\s*([a-z]+))?\s*-\s*(\d{1,2})(?:\s*([a-z]+))?"#
        
        guard let regex = try? NSRegularExpression(pattern: pattern) else {
            return (nil, nil)
        }
        
        let range = NSRange(line.startIndex..., in: line)
        
        guard let match = regex.firstMatch(in: line, range: range) else {
            return (nil, nil)
        }
        
        func get(_ index: Int) -> String? {
            guard let r = Range(match.range(at: index), in: line) else { return nil }
            let val = String(line[r]).trimmingCharacters(in: .whitespaces)
            return val.isEmpty ? nil : val
        }
        
        let startDay = Int(get(1) ?? "") ?? 0
        let endDay = Int(get(3) ?? "") ?? 0
        
        let startMonthText = get(2)
        let endMonthText = get(4)
        
        let startMonthKey = startMonthText ?? endMonthText
        let endMonthKey = endMonthText ?? startMonthText
        
        guard let smKey = startMonthKey,
              let emKey = endMonthKey,
              let startMonth = parseMonth(smKey),
              let endMonth = parseMonth(emKey) else {
            return (nil, nil)
        }
        
        let startDate = buildDate(day: startDay, month: startMonth, year: year)
        let endDate = buildDate(day: endDay, month: endMonth, year: year)
        
        return (startDate, endDate)
    }
    
    // MAIN PARSER
    func parseOrderText(_ text: String, products: [Products]) -> OrderDraft {
        
        var draft = OrderDraft()
        var items: [OrderItemDraft] = []
        var currentItem: OrderItemDraft?
        
        let lines = text.components(separatedBy: .newlines)
        
        for rawLine in lines {
            
            let line = rawLine.trimmingCharacters(in: .whitespacesAndNewlines)
            guard !line.isEmpty else { continue }
            
            let parts = line.components(separatedBy: ":")
            
            if parts.count >= 2 {
                
                let key = parts[0].trimmingCharacters(in: .whitespaces)
                let value = parts[1].trimmingCharacters(in: .whitespaces)
                
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
                    
                    if let item = currentItem {
                        items.append(item)
                    }
                    
                    var newItem = OrderItemDraft()
                    
                    if let matched = matchProduct(from: value, products: products) {
                        newItem.selectedProduct = matched
                        newItem.productName = matched.name
                        newItem.color = matched.color
                        newItem.price = matched.price
                    }
                    
                    currentItem = newItem
                    
                case "Size":
                    currentItem?.size = value
                    
                default:
                    break
                }
            }
        }
        
        if let item = currentItem {
            items.append(item)
        }
        
        draft.items = items
        
        let (start, end) = extractDates(from: text)
        draft.rentStartDate = start ?? Date()
        draft.rentEndDate = end ?? Date()
        
        return draft
    }
    
    // LOAD PRODUCTS
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
