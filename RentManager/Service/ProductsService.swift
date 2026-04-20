//
//  ProductsService.swift
//  RentManager
//
//  Created by Edward Suwandi on 28/02/26.
//

import Foundation
import Supabase

struct ProductsService {
    
    func fetchProducts() async throws -> [Products] {
        let products: [Products] = try await supabase
            .from("products")
            .select()
            .execute()
            .value
        
        return products
    }
    
    // MARK: - INSERT PRODUCT
    func insertProduct(_ product: Products) async throws {
        try await supabase
            .from("products")
            .insert(product)
            .execute()
    }
    
    // MARK: - UPDATE PRODUCT
    func updateProduct(_ product: Products) async throws {
        try await supabase
            .from("products")
            .update(product)
            .eq("id", value: product.id)
            .execute()
    }
    
    // MARK: - DELETE PRODUCT
    func deleteProduct(id: UUID) async throws {
        try await supabase
            .from("products")
            .delete()
            .eq("id", value: id)
            .execute()
    }
}
    
