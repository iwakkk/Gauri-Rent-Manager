//
//  ProductsService.swift
//  RentManager
//
//  Created by Edward Suwandi on 28/02/26.
//

import Foundation
import Supabase
import UIKit

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

    
    func uploadImage(_ data: Data) async throws -> String {
        
        guard let image = UIImage(data: data),
              let compressed = image.jpegData(compressionQuality: 0.3) else {
            throw URLError(.badURL)
        }
        
        let fileName = "\(UUID().uuidString).jpg"
        
        try await supabase.storage
            .from("product-images")
            .upload(
                path: fileName,
                file: compressed,
                options: FileOptions(
                    contentType: "image/jpeg",
                    upsert: true
                )
            )
        
        let publicURL = try supabase.storage
            .from("product-images")
            .getPublicURL(path: fileName)
        
        return publicURL.absoluteString
    }
}
    
