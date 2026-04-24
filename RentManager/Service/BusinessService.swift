//
//  BusinessService.swift
//  RentManager
//
//  Created by Edward Suwandi on 21/04/26.
//

import Foundation
import Supabase

struct BusinessService {
    
    // fetch business profile
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
    
}
