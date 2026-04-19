//
//  MainTabView.swift
//  RentManager
//
//  Created by Edward Suwandi on 24/03/26.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            AllOrdersView()
                .tabItem {
                    Label("Orders", systemImage: "list.bullet")
                }
            
            CalendarView()
                .tabItem {
                    Label("Calendar", systemImage: "calendar")
                }
            
            ProductsView()
                .tabItem {
                    Label("Products", systemImage: "square.grid.2x2")
                }
            
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.circle")
                }
        }
    }
}
