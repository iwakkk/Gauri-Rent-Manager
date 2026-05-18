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
    
    // Load booked product date range
    func loadBookedRanges(for productId: UUID) async {
        do {
            let result = try await orderService.fetchProductBookings(productId: productId)
            
            bookedRanges[productId] = result.compactMap { item in
                guard let start = item.rentStartDate,
                      let end = item.rentEndDate else {
                    return nil
                }
                return (start, end)
            }
            
        } catch {
            print("error:", error)
        }
    }
    
    // Check Product Conflicts
    func checkConflicts(
        products: [Products],
        startDate: Date,
        endDate: Date
    ) -> (hasConflict: Bool, message: String) {
        
        // Store conflict messages
        var messages: [String] = []
        
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM"
        formatter.locale = Locale(identifier: "id_ID")
        
        // Loop each product
        for product in products {
            
            // Get date range for the products
            let ranges = bookedRanges[product.id] ?? []
            
            // Filter ranges that overlap with selected date range
            let conflicts = ranges.filter { (start, end) in
                startDate <= end && endDate >= start
            }
            
            // Skip to next product if there is no conflict
            if conflicts.isEmpty { continue }
            
            // Create message
            let scheduleText = ranges.map {
                "• \(formatter.string(from: $0.0)) - \(formatter.string(from: $0.1))"
            }.joined(separator: "\n")
            
            let message = """
            \(product.name)

            Existing Orders:
            \(scheduleText)
            """
            
            messages.append(message)
        }
        
        if messages.isEmpty {
            return (false, "")
        }
        
        let finalMessage = """
        These products are not available:

        \(messages.joined(separator: "\n\n----------------\n\n"))

        Please choose different dates.
        """
        
        return (true, finalMessage)
    }
}
