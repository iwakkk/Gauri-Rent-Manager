//
//  Title.swift
//  RentManager
//
//  Created by Edward Suwandi on 09/02/26.
//

import SwiftUI

struct Title: View {
    @EnvironmentObject var appState: AppState

    let title: String
    
    let actionIcon: String?
    let actionTap: (() -> Void)?

    var body: some View {
        HStack {
            
            Text(title)
                .font(.largeTitle.bold())
                .foregroundColor(.gauritext)
            Spacer()

            if let icon = actionIcon, let action = actionTap {
                Button(action: action) {
                    Image(systemName: icon)
                        .font(.largeTitle)
                }
            }

            // Profile Menu
            Menu {
                // Username
                if let user = appState.currentUser {
                    Button("\(user.email) (\(user.role))") {}
                }

                Divider()

                Button(role: .destructive) {
                    handleLogout()
                } label: {
                    Text("Log Out")
                }

            } label: {
                Image(systemName: "person.circle")
                    .font(.largeTitle)
            }
        }
        .foregroundColor(.gauriprimary)
        .padding()
    }

    // GLOBAL LOGOUT
    private func handleLogout() {
        
        appState.currentUser = nil
        
    }
}

#Preview {
    ContentView()
        .environmentObject(AppState())
}
