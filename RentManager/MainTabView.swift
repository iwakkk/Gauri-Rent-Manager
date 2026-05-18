//
//  MainTabView.swift
//  RentManager
//
//  Created by Edward Suwandi on 24/03/26.
//

import SwiftUI

struct MainTabView: View {
    
    // Access global app navigation state
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        
        // Apply global app navigation state
        TabView(selection: $appState.selectedTab) {
            AllOrdersView()
                .tabItem {
                    Label("Orders", systemImage: "list.bullet")
                }
                .tag(0)
            
            CalendarView()
                .tabItem {
                    Label("Calendar", systemImage: "calendar")
                }
                .tag(1)
            
            ProductsView()
                .tabItem {
                    Label("Products", systemImage: "hanger")
                }
                .tag(2)
            
            BusinessView()
                .tabItem {
                    Label("Business", systemImage: "storefront")
                }
                .tag(3)
        }
        .tint(Color.gauriprimary)
    }
}
