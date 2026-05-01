//
//  OrderEmptyState.swift
//  RentManager
//
//  Created by Edward Suwandi on 23/04/26.
//

import SwiftUI

struct OrderEmptyState : View {
    var body: some View {
        VStack(spacing: 12) {
                Image(systemName: "tray")
                    .font(.system(size: 40))
                    .foregroundColor(.gray)

                Text("No orders found")
                    .font(.headline)
                    .foregroundColor(.gray)

                Text("Try changing your filter or add a new order.")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
    }
}

#Preview {
    ContentView()
        .environmentObject(AppState())
}

