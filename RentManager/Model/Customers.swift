//
//  Customers.swift
//  RentManager
//
//  Created by Edward Suwandi on 17/04/26.
//

import Foundation

struct Customers: Codable, Identifiable, Hashable {
    let id: UUID
    let name: String
    let phone: String
    let bankAccount: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case phone
        case bankAccount = "bank_account"
    }
}
