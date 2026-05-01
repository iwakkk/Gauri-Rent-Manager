//
//  OrderItemSection.swift
//  RentManager
//
//  Created by Edward Suwandi on 01/05/26.
//

import SwiftUI

struct OrderItemsSection: View {
    let items: [OrderItems]
    let isLoading: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Ordered Item(s)")
                .font(.title3.weight(.bold))
            
            if isLoading {
                ProgressView()
            } else if items.isEmpty {
                Text("No items found")
                    .foregroundColor(.secondary)
            } else {
                ForEach(items) { item in
                    OrderItemRow(item: item)
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(10)
    }
}
