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
    
//    func save() async {
//        guard let profile else { return }
//        
//        do {
//            try await service.updateBusinessProfile(profile)
//        } catch {
//            print("save error:", error)
//        }
//    }
}
