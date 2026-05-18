//
//  ContentView.swift
//  RentManager
//
//  Created by Edward Suwandi on 20/01/26.
//

import SwiftUI

struct ContentView: View {
    
    // Access global app state
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        NavigationStack {
            
            if appState.currentUser != nil {
                MainTabView()
            } else {
                LoginView()
            }
        }
        // Handle Share Extension
        .onOpenURL { url in
            if url.host == "new-booking" {
                
                // Check if user has logged in or not
                if appState.currentUser != nil {
                    
                    // Change global state to open orders tab and show new order sheet
                    appState.selectedTab = 0
                    appState.shouldOpenNewOrder = true
                }
            }
        }
    }
}

