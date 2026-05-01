//
//  OrderItemRow.swift
//  RentManager
//
//  Created by Edward Suwandi on 01/05/26.
//

import SwiftUI

struct OrderItemRow: View {
    let item: OrderItems
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            
            if let urlString = item.products?.imageUrl,
               let url = URL(string: urlString) {
                
                AsyncImage(url: url) { image in
                    image.resizable().scaledToFill()
                } placeholder: {
                    Color.gray.opacity(0.2)
                }
                .frame(width: 70, height: 70)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                
            } else {
                Color.gray.opacity(0.2)
                    .frame(width: 70, height: 70)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            
            VStack(alignment: .leading, spacing: 6) {
                Text("\(item.products?.name ?? "-") - \(item.products?.color ?? "-")")
                    .font(.body.weight(.semibold))
                
                Text("Qty: \(item.quantity)")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Text("Size: \(item.size)")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Text("Subtotal: Rp \(Int(item.subtotal))")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding(10)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}
