//
//  AppState.swift
//  RentManager
//
//  Created by Edward Suwandi on 13/04/26.
//

import SwiftUI
import Combine
    
@MainActor
class AppState: ObservableObject {
    
    // Store currently logged-in user
    @Published var currentUser: Users?
    
    // Used to switch tab and open New Order View from Share Extension
    @Published var selectedTab = 0
    @Published var shouldOpenNewOrder = false
    
    private let isDevMode = true
        
        init() {
            if isDevMode {
                injectDummyUser()
            }
        }
        
        private func injectDummyUser() {
            self.currentUser = Users(
                id: UUID(),
                email: "Edward@gmail.com",
                role: "Staff"
            )
        }
    
}
