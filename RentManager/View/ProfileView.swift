//
//  ProfileView.swift
//  RentManager
//
//  Created by Edward Suwandi on 13/04/26.
//

import SwiftUI

struct ProfileView: View {
    
    @EnvironmentObject var appState: AppState
    
    @State private var showProfileSheet = false
    @State private var showPaymentSheet = false
    @State private var showProductSheet = false
    @State private var products: [Products] = []
    
    var body: some View {
        NavigationStack {
            VStack {
                List {
//                    if let user = appState.currentUser {
//                        BusinessCard(user: user)
//                    }
                    MenuRow(icon: "person.circle", title: "Edit Profile", bools: $showProfileSheet)
                    MenuRow(icon: "creditcard", title: "Payment Information", bools: $showPaymentSheet)
                    MenuRow(icon: "square.grid.2x2", title: "Products", bools: $showProductSheet)
                    
                    LogOutButton()
                }
                .scrollContentBackground(.hidden)
                
                
            }
            .sheet(isPresented: $showProfileSheet) {
//                if let user = appState.currentUser {
//                        EditBusinessView(user: user)
//                    }
            }
            .sheet(isPresented: $showProductSheet) {
               ProductsView()
            }
            .navigationTitle("Profile")
        }
    }
    
}

struct LogOutButton: View {
    
    var body: some View {
        Button {
            // to do : log out button
        } label: {
            Label("Log Out", systemImage: "rectangle.portrait.and.arrow.right")
                .foregroundStyle(Color(.red))
        }
    }
}

struct MenuRow: View {
    let icon: String
    let title: String
    @Binding var bools: Bool
    
    var body: some View {
        HStack {
            Button {
                bools = true
            } label: {
                Label(title, systemImage: icon)
                    .foregroundStyle(Color(.label))
                
            }
            Spacer()
            Image(systemName: "chevron.right")
        }
    }
}
#Preview {
    ProfileView()
}
