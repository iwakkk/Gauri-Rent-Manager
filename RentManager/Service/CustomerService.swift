//
//  CustomerService.swift
//  RentManager
//
//  Created by Edward Suwandi on 18/04/26.
//

import Foundation
import Supabase

struct CustomerService {
    
    func fetchCustomers() async throws -> [Customers] {
        let response: [Customers] = try await supabase
            .from("customers")
            .select("*")
            .execute()
            .value
        
        return response
    }
    
}
