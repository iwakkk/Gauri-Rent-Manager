//
//  BusinessProfileViewModel.swift
//  RentManager
//
//  Created by Edward Suwandi on 21/04/26.
//

import SwiftUI

@MainActor
@Observable
class BusinessProfileViewModel {
    
    var business: BusinessProfile?
    var isLoading = false
    
    let service = BusinessService()
    
    func loadBusinessProfile() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            business = try await service.fetchBusinessProfile()
        } catch {
            print("load error:", error)
        }
    }
    
    func updateBusiness(with draft: BusinessProfileDraft) async {
        guard let current = business else { return }
        
        let updated = BusinessProfile(
            id: current.id,
            email: draft.email, businessName: draft.name,
            businessPhone: draft.phone,
            businessAddress: draft.address,
            bankName: draft.bankName,
            bankNumber: draft.bankNumber,
            bankAccountName: draft.bankAccountName,
            businessImageURL: current.businessImageURL
        )
        print("📦 Prepared updated model:")
           print("   id: \(updated.id)")
        do {
            try await service.updateBusinessProfile(updated)
            business = try await service.fetchBusinessProfile()
        } catch {
            print("update error:", error)
        }
    }
}
