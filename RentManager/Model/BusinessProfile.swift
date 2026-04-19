//
//  BusinessProfile.swift
//  RentManager
//
//  Created by Edward Suwandi on 17/04/26.
//

import Foundation
import Supabase

struct BusinessProfile: Codable{
    let id: UUID
    let email: String
    let businessName: String
    let businessPhone: Int
    let businessAddress: String
    let bankName: String
    let bankNumber: Int
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case email = "email"
        case businessName = "business_name"
        case businessPhone = "business_phone"
        case businessAddress = "business_address"
        case bankName = "bank_name"
        case bankNumber = "bank_number"
    }
}

struct BusinessProfileService {
    
    func fetchBusinessProfile() async throws -> [BusinessProfile] {
        let businessProfile: [BusinessProfile] = try await supabase
            .from("business_profile")
            .select()
            .execute()
            .value
            
        print("Users from DB:")
              for business in businessProfile {
                  print("ID: \(business.id)")
                  print("Email: \(business.email)")
                  print("Business: \(business.businessName)")
                  print("Phone: \(business.businessPhone)")
                  print("Address: \(business.businessAddress)")
                  print("Bank: \(business.bankName) - \(business.bankNumber)")
                  print("--------")
              }
        
        return businessProfile
    }
}
