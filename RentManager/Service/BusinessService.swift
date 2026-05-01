//
//  BusinessService.swift
//  RentManager
//
//  Created by Edward Suwandi on 21/04/26.
//

import Foundation
import Supabase

struct BusinessService {
    
    // FETCH BUSINESS PROFILE
    func fetchBusinessProfile() async throws -> BusinessProfile {
        let response: BusinessProfile = try await supabase
            .from("business_profile")
            .select()
            .single()
            .execute()
            .value
        
        print("✅ Success fetch business profile:")
              print(response)
              
        
        return response
    }
    
    // UPDATE BUSINESS PROFILE
    func updateBusinessProfile(_ business: BusinessProfile) async throws {
        try await supabase
            .from("business_profile")
            .update([
                "business_name": business.businessName,
                "business_phone": business.businessPhone,
                "business_address": business.businessAddress,
                "email": business.email,
                "bank_name": business.bankName,
                "bank_number": business.bankNumber,
                "bank_account_name": business.bankAccountName
            ])
            .eq("id", value: business.id)
            .execute()
    }
    
}
