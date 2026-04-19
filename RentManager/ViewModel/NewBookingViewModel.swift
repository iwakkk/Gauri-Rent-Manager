//
//  NewBookingViewModel.swift
//  RentManager
//
//  Created by Edward Suwandi on 19/02/26.
//

import Foundation
import SwiftUI

@Observable
class NewBookingViewModel {
    
    var parsedDraft: BookingDraft?
    var allProducts: [Products] = []
    var isLoading = false
    
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
    
    func extractDates(from text: String) -> (Date?, Date?) {
        
        // supaya 6oct -> 6 oct
        let normalized = text.replacingOccurrences(
            of: #"(\d)([a-zA-Z]{3,})"#,
            with: "$1 $2",
            options: .regularExpression
        ).lowercased()
        
        let pattern = #"(\d{1,2})\s*([a-z]{3,})?\s*-\s*(\d{1,2})\s*([a-z]{3,})"#
        
        guard let regex = try? NSRegularExpression(pattern: pattern) else {
            return (nil, nil)
        }
        
        let range = NSRange(normalized.startIndex..., in: normalized)
        
        guard let match = regex.firstMatch(in: normalized, options: [], range: range) else {
            return (nil, nil)
        }
        
        func value(_ i: Int) -> String? {
            guard let r = Range(match.range(at: i), in: normalized) else { return nil }
            return String(normalized[r])
        }
        
        guard let startDay = value(1),
              let endDay = value(3) else { return (nil, nil) }
        
        let startMonth = value(2)
        let endMonth = value(4) ?? startMonth
        
        guard let month = endMonth else { return (nil, nil) }
        
        let year = Calendar.current.component(.year, from: Date())
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "d MMM yyyy"
        
        let startDate = formatter.date(from: "\(startDay) \(startMonth ?? month) \(year)")
        let endDate = formatter.date(from: "\(endDay) \(month) \(year)")
        
        return (startDate, endDate)
    }
    
    func detectUsingDataDetector(_ text: String) -> (Date?, Date?)? {
        
        guard let detector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.date.rawValue) else {
            return nil
        }
        
        let matches = detector.matches(
            in: text,
            options: [],
            range: NSRange(text.startIndex..., in: text)
        )
        
        let dates = matches.compactMap { $0.date }
        
        if dates.count >= 2 {
            return (dates[0], dates[1])
        }
        
        if dates.count == 1 {
            return (dates[0], nil)
        }
        
        return nil
    }
    
    func detectUsingRegex(_ text: String) -> (Date?, Date?)? {
        
        let pattern = #"(\d{1,2})\s*(january|february|march|april|may|june|july|august|september|october|november|december)?\s*-\s*(\d{1,2})\s*(january|february|march|april|may|june|july|august|september|october|november|december)?"#
        
        guard let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive) else {
            return nil
        }
        
        let range = NSRange(text.startIndex..., in: text)
        
        guard let match = regex.firstMatch(in: text, options: [], range: range) else {
            return nil
        }
        
        func value(_ index: Int) -> String? {
            guard let r = Range(match.range(at: index), in: text) else { return nil }
            return String(text[r])
        }
        
        guard let startDay = value(1),
              let endDay = value(3) else {
            return nil
        }
        
        let startMonth = value(2)
        let endMonth = value(4) ?? startMonth
        
        guard let month = endMonth else { return nil }
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.dateFormat = "d MMMM yyyy"
        
        let year = Calendar.current.component(.year, from: Date())
        
        let startString = "\(startDay) \(startMonth ?? month) \(year)"
        let endString = "\(endDay) \(month) \(year)"
        
        let startDate = formatter.date(from: startString)
        let endDate = formatter.date(from: endString)
        
        return (startDate, endDate)
    }
    
    
    // MARK: Function to parse text form to fields
    func parseBookingText(_ text: String) -> BookingDraft {
        
        var draft = BookingDraft()
        var result: [String: String] = [:]
        
        let lines = text.components(separatedBy: .newlines)
        
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
        
        draft.customerName = result["Nama"] ?? ""
        draft.customerAddress = result["Alamat"] ?? ""
        draft.customerPhone = result["No Hp"] ?? ""
        draft.customerBankAccount = result["No rekening pengembalian deposit"] ?? ""
        
        if result["Dress"] != nil {
            var item = BookingItemDraft()
            item.selectedProduct = nil
            draft.items = [item]
        }
        
        // Extract date automatically
        let (startDate, endDate) = extractDates(from: text)

        draft.rentStartDate = startDate ?? Date()
        draft.rentEndDate = endDate ?? Date()

        return draft
    }
    
    // MARK: Function to load all products
    func loadProducts() async {
        isLoading = true
        do {
            allProducts = try await ProductsService().fetchProducts()
            print("Products loaded:", allProducts.count)
        } catch {
            print("Error fetch products:", error)
        }
        isLoading = false
    }
    
    
}
