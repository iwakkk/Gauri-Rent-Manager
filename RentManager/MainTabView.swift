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
                    Label("Products", systemImage: "hanger")
                }
            
            BusinessView()
                .tabItem {
                    Label("Business", systemImage: "storefront")
                }
        }
        .tint(Color.gauriprimary)
    }
}
