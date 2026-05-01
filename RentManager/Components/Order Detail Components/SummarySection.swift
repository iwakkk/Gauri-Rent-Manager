//
//  SummarySection.swift
//  RentManager
//
//  Created by Edward Suwandi on 01/05/26.
//

import SwiftUI

struct SummarySection: View {
    let order: Orders
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Summary")
                .font(.title3.weight(.bold))
            
            HStack {
                Text("Subtotal")
                Spacer()
                Text("Rp \(Int(order.subtotalAmount ?? 0))")
            }
            
            HStack {
                Text("Shipping Fee")
                Spacer()
                Text("Rp \(Int(order.shippingFee ?? 0))")
            }
            
            HStack {
                Text("Deposit")
                Spacer()
                Text("Rp \(Int(order.depositAmount ?? 0))")
            }
            
            Divider().padding(.vertical)
            
            HStack {
                Text("Total").font(.body.bold())
                Spacer()
                Text("Rp \(Int(order.totalAmount ?? 0))")
                    .font(.body.bold())
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(10)
    }
}
