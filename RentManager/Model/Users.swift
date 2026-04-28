//
//  Users.swift
//  RentManager
//
//  Created by Edward Suwandi on 09/02/26.
//

import Foundation
import Supabase

//struct Users: Codable{
//    let id: UUID
//    let email: String
//    let password: String
//    let businessName: String
//    let businessPhone: Int
//    let businessAddress: String
//    let bankName: String
//    let bankNumber: Int
//    
//    enum CodingKeys: String, CodingKey {
//        case id = "id"
//        case email = "email"
//        case password = "password"
//        case businessName = "business_name"
//        case businessPhone = "business_phone"
//        case businessAddress = "business_address"
//        case bankName = "bank_name"
//        case bankNumber = "bank_number"
//    }
//}
//
//struct UsersService {
//    
//    func fetchUsers() async throws -> [Users] {
//        let users: [Users] = try await supabase
//            .from("users")
//            .select()
//            .execute()
//            .value
//            
//        print("Users from DB:")
//              for user in users {
//                  print("ID: \(user.id)")
//                  print("Email: \(user.email)")
//                  print("Password: \(user.password)")
//                  print("Business: \(user.businessName)")
//                  print("Phone: \(user.businessPhone)")
//                  print("Address: \(user.businessAddress)")
//                  print("Bank: \(user.bankName) - \(user.bankNumber)")
//                  print("--------")
//              }
//        
//        return users
//    }
//}

struct Users: Codable, Identifiable, Hashable {
    let id: UUID
    let email: String
    let role: String
}

struct UsersService {

    func fetchUsers() async throws -> [Users] {
        let users: [Users] = try await supabase
            .from("users")
            .select()
            .execute()
            .value

        print("Users from DB:")
              for user in users {
                  print("ID: \(user.id)")
                  print("Email: \(user.email)")
                  print("--------")
              }

        return users
    }
}
