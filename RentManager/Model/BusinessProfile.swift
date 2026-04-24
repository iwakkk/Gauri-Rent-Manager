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
    let businessPhone: String
    let businessAddress: String
    let bankName: String
    let bankNumber: String
    let bankAccountName: String
    let businessImageURL: String
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case email = "email"
        case businessName = "business_name"
        case businessPhone = "business_phone"
        case businessAddress = "business_address"
        case bankName = "bank_name"
        case bankNumber = "bank_number"
        case bankAccountName = "bank_account_name"
        case businessImageURL = "business_image_url"
    }
}
