//
//  NewBookingViewModel.swift
//  RentManager
//
//  Created by Edward Suwandi on 19/02/26.
//

import Foundation

@Observable
class NewBookingViewModel {
    
    var parsedDraft: BookingDraft?
    var allProducts: [Products] = []
    var isLoading = false
    
    // MONTH NORMALIZER
    func normalizeMonth(_ text: String) -> String {
        
        var result = text.lowercased()
        
        let monthMap: [String: String] = [
            "januari": "january", "jan": "january",
            "februari": "february", "feb": "february",
            "maret": "march", "mar": "march",
            "april": "april", "apr": "april",
            "mei": "may",
            "juni": "june", "jun": "june",
            "juli": "july", "jul": "july",
            "agustus": "august", "agu": "august", "aug": "august",
            "september": "september", "sep": "september",
            "oktober": "october", "okt": "october", "oct": "october",
            "november": "november", "nov": "november",
            "desember": "december", "des": "december", "dec": "december"
        ]
        
        for (indo, eng) in monthMap {
            result = result.replacingOccurrences(of: indo, with: eng)
        }
        
        return result
    }
    
    // PRODUCT MATCH
    func matchProduct(from text: String, products: [Products]) -> Products? {
        
        let query = text
            .lowercased()
            .replacingOccurrences(of: "-", with: " ")
            .trimmingCharacters(in: .whitespacesAndNewlines)
        
        let words = query.components(separatedBy: " ")
        
        let scoredProducts = products.map { product -> (product: Products, score: Int) in
            
            let name = product.name.lowercased()
            let color = product.color.lowercased()
            
            var score = 0
            
            for word in words {
                if name.contains(word) {
                    score += 2
                }
                if color.contains(word) {
                    score += 3
                }
            }
            
            return (product, score)
        }
        
        return scoredProducts
            .sorted { $0.score > $1.score }
            .first?
            .product
    }
    
    // DATE EXTRACTION
    func extractDates(from text: String) -> (Date?, Date?) {
        
        let normalizedText = normalizeMonth(text.lowercased())
        let year = Calendar.current.component(.year, from: Date())
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "d MMMM yyyy"
        
        let lines = normalizedText.components(separatedBy: .newlines)
        
        guard let line = lines.first(where: { $0.contains("periode sewa") }) else {
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
        
        func get(_ i: Int) -> String? {
            guard let r = Range(match.range(at: i), in: line) else { return nil }
            let val = String(line[r]).trimmingCharacters(in: .whitespaces)
            return val.isEmpty ? nil : val
        }
        
        let startDay = Int(get(1) ?? "") ?? 0
        let startMonth = get(2)
        
        let endDay = Int(get(3) ?? "") ?? 0
        let endMonth = get(4)
        
        let sm = startMonth ?? endMonth
        let em = endMonth ?? startMonth ?? startMonth
        
        guard let finalStartMonth = sm,
              let finalEndMonth = em else { return (nil, nil) }
        
        let startDate = formatter.date(from: "\(startDay) \(finalStartMonth) \(year)")
        let endDate = formatter.date(from: "\(endDay) \(finalEndMonth) \(year)")
        
        return (startDate, endDate)
    }
    
    
    // MAIN PARSER
    func parseBookingText(_ text: String, products: [Products]) -> BookingDraft {
        
        var draft = BookingDraft()
        var result: [String: String] = [:]
        
        let lines = text.components(separatedBy: .newlines)
        
        // PARSE KEY : VALUE
        for line in lines {
            if line.contains(":") {
                let parts = line.components(separatedBy: ":")
                
                if parts.count >= 2 {
                    let key = parts[0].trimmingCharacters(in: .whitespaces)
                    let value = parts[1].trimmingCharacters(in: .whitespaces)
                    result[key] = value
                }
            }
        }
        
        // CUSTOMER
        draft.customerName = result["Nama"] ?? ""
        draft.customerAddress = result["Alamat"] ?? ""
        draft.customerPhone = result["No Hp"] ?? ""
        draft.customerBankAccount = result["No rekening pengembalian deposit"] ?? ""
        
        // PRODUCT
        let dressText = result["Dress"] ?? ""
        let sizeText = result["Size"] ?? ""
        
        if !dressText.isEmpty {
            
            var item = BookingItemDraft()
            
            if let matched = matchProduct(from: dressText, products: products) {
                item.selectedProduct = matched
                item.productName = matched.name
                item.color = matched.color
                item.price = matched.price
            }
            
            if !sizeText.isEmpty {
                item.size = sizeText
            }
            
            draft.items = [item]
        }
        
        // DATE
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
