//
//  ProductsViewModel.swift
//  RentManager
//
//  Created by Edward Suwandi on 20/04/26.
//

import Foundation

@Observable
class ProductsViewModel {
    
    var products: [Products] = []
    var isLoading = false
    var bookedRanges: [UUID: [(Date, Date)]] = [:]
    var recoveryRanges: [UUID: [(Date, Date)]] = [:]
    var recoveryState: [UUID: [(Date, Date)]] = [:]
    
    private let service = ProductsService()
    private let orderService = OrderService()
    
    // Validate product form
    func isValid(draft: ProductDraft) -> Bool {
        guard !draft.name.trimmingCharacters(in: .whitespaces).isEmpty else { return false }
        guard !draft.color.trimmingCharacters(in: .whitespaces).isEmpty else { return false }
        guard draft.price > 0 else { return false }
        
        return true
    }
    
    // Create product
    func createProduct(from draft: ProductDraft, imageData: Data?) async {
        do {
            var imageUrl: String? = nil
            
            // OPTIONAL: upload image kalau ada
            if let imageData {
                imageUrl = try await service.uploadImage(imageData)
            }
            
            let product = Products(
                id: draft.id,
                name: draft.name,
                color: draft.color,
                size: draft.size,
                price: draft.price,
                imageUrl: imageUrl
            )
            
            try await service.insertProduct(product)
            await loadProducts()
            
        } catch {
            print("create product error:", error)
        }
    }
    
    // Load products
    func loadProducts() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            products = try await service.fetchProducts()
            
            for product in products {
                await loadBookedRanges(for: product.id)
                await loadRecoveryRanges(for: product.id)
            }
            
        } catch {
            print("fetch error:", error)
        }
    }
    
    
    // Update product
    func updateProduct(_ product: Products) async {
        do {
            try await service.updateProduct(product)
            await loadProducts()
        } catch {
            print("update error:", error)
        }
    }
    
    // Delete product
    func deleteProduct(id: UUID) async {
        do {
            try await service.deleteProduct(id: id)
            await loadProducts()
        } catch {
            print("delete error:", error)
        }
    }
    
//    // Load booked product date range
//    func loadBookedRanges(for productId: UUID) async {
//        do {
//            let result = try await orderService.fetchProductBookings(productId: productId)
//            
//            bookedRanges[productId] = result.compactMap { item in
//                guard let start = item.rentStartDate,
//                      let end = item.rentEndDate else {
//                    return nil
//                }
//                return (start, end)
//            }
//            
//        } catch {
//            print("error:", error)
//        }
//    }
    
    // MARK: - Load Booked + Recovery Ranges
    func loadBookedRanges(for productId: UUID) async {
        do {
            let result = try await orderService.fetchProductBookings(productId: productId)
            
            let rentRanges: [(Date, Date)] = result.compactMap { item in
                
                guard let start = item.rentStartDate,
                      let end = item.rentEndDate else {
                    return nil
                }
                
                // ONLY active rentals block booking
                if item.status == "to_ship" || item.status == "in_use" {
                    return (start, end)
                }
                
                return nil
            }
            
            bookedRanges[productId] = rentRanges
            
        } catch {
            print("error loading bookings:", error)
        }
    }
    
    func loadRecoveryRanges(for productId: UUID) async {
        do {
            let result = try await orderService.fetchProductBookings(productId: productId)
            
            let now = Date()
            
            let recovery: [(Date, Date)] = result.compactMap { item in
                
                guard item.status == "completed",
                      item.condition != "good",
                      let end = item.rentEndDate,
                      let available = item.availableAgainDate else {
                    return nil
                }
                
                if available <= now {
                    return nil
                }
                
                return (end, available)
            }
            
            recoveryRanges[productId] = recovery
            
        } catch {
            print("error loading recovery:", error)
        }
    }
    
    func normalize(_ date: Date) -> Date {
        let calendar = Calendar.current
        return calendar.startOfDay(for: date)
    }
    
    func checkConflicts(
        products: [Products],
        startDate: Date,
        endDate: Date
    ) -> (hasConflict: Bool, message: String) {
        
        var messages: [String] = []
        
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM"
        formatter.locale = Locale(identifier: "id_ID")
        
        for product in products {
            
            let rentRanges = bookedRanges[product.id] ?? []
            let recoveryRanges = recoveryRanges[product.id] ?? []
            
            // RENT CONFLICT
            let rentConflict = rentRanges.filter {
                let startA = normalize(startDate)
                let endA = normalize(endDate)
                let startB = normalize($0.0)
                let endB = normalize($0.1)
                
                return startA <= endB && endA >= startB
            }
            
            // RECOVERY CONFLICT
            let recoveryConflict = recoveryRanges.filter { _, availableDate in
                normalize(startDate) <= normalize(availableDate)
            }
            
            if rentConflict.isEmpty && recoveryConflict.isEmpty {
                continue
            }
            
            let rentText = rentConflict.map {
                "RENT: \(formatter.string(from: $0.0)) - \(formatter.string(from: $0.1))"
            }
            
            let recoveryText = recoveryConflict.map {
                "REPAIR BLOCK: \(formatter.string(from: $0.0)) - \(formatter.string(from: $0.1))"
            }
            
            messages.append("""
            \(product.name)

            \(rentText.joined(separator: "\n"))
            \(recoveryText.joined(separator: "\n"))
            """)
        }
        
        if messages.isEmpty {
            return (false, "")
        }
        
        return (true, """
        These products are not available:

        \(messages.joined(separator: "\n\n----------------\n\n"))
        """)
    }
}
