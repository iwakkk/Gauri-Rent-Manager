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
}
    