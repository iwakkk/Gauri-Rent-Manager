//
//  RentManagerApp.swift
//  RentManager
//
//  Created by Edward Suwandi on 20/01/26.
//

import SwiftUI

@main
struct RentManagerApp: App {
    
    @StateObject private var appState = AppState()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appState)
        }
    }
}
