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
    
    @Published var currentUser: Users?
    
    private let isDevMode = false
        
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
