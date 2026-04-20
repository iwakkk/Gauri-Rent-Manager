//
//  ProductsViewModel.swift
//  RentManager
//
//  Created by Edward Suwandi on 20/04/26.
//

import Foundation
import Observation

@Observable
class ProductsViewModel {
    
    var products: [Products] = []
    var isLoading = false
    
    private let service = ProductsService()
    
    func isValid(draft: ProductDraft) -> Bool {
        guard !draft.name.trimmingCharacters(in: .whitespaces).isEmpty else { return false }
        guard !draft.color.trimmingCharacters(in: .whitespaces).isEmpty else { return false }
        guard draft.price > 0 else { return false }
        
        return true
    }
    
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
                isRented: draft.isRented,
                imageUrl: imageUrl
            )
            
            try await service.insertProduct(product)
            await loadProducts()
            
        } catch {
            print("❌ create product error:", error)
        }
    }
    
    // MARK: Fetch
    func loadProducts() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            products = try await service.fetchProducts()
        } catch {
            print("❌ fetch error:", error)
        }
    }
    
    
    // MARK: Update
    func updateProduct(_ product: Products) async {
        do {
            try await service.updateProduct(product)
            await loadProducts()
        } catch {
            print("❌ update error:", error)
        }
    }
    
    // MARK: Delete
    func deleteProduct(id: UUID) async {
        do {
            try await service.deleteProduct(id: id)
            await loadProducts()
        } catch {
            print("❌ delete error:", error)
        }
    }
}
