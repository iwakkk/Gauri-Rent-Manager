//
//  ContentView.swift
//  RentManager
//
//  Created by Edward Suwandi on 20/01/26.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var appState: AppState
    @State private var goToNewBooking = false
    
    var body: some View {
        NavigationStack {
            
            if appState.currentUser != nil {
                MainTabView()
                    .navigationDestination(isPresented: $goToNewBooking) {
                        NewOrderView(showOrderSheet: .constant(false))
                    }
            } else {
                LoginView()
            }
        }
        .onOpenURL { url in
            if url.host == "new-booking" {
                if appState.currentUser != nil {
                    goToNewBooking = true
                }
            }
        }
    }
}

