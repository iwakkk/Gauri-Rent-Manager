//
//  RentDetailSection.swift
//  RentManager
//
//  Created by Edward Suwandi on 01/05/26.
//

import SwiftUI

struct RentDetailSection: View {
    let order: Orders
    let rentPeriod: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Rent Details")
                .font(.title3.weight(.bold))
            
            HStack {
                RowField(title: "Rent Period", value: rentPeriod)
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    Text("Status")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Text(order.status.displayName)
                        .font(.caption.bold())
                        .foregroundColor(order.status.color)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(order.status.color.opacity(0.15))
                        .clipShape(Capsule())
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(10)
    }
}
