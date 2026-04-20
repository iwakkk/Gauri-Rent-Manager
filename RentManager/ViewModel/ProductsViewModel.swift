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
    
    // MARK: Add
    func addProduct(_ product: Products) async {
        do {
            try await service.insertProduct(product)
            await loadProducts()
        } catch {
            print("❌ add error:", error)
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
