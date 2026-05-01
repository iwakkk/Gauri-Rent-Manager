//
//  CustomerInfoSection.swift
//  RentManager
//
//  Created by Edward Suwandi on 01/05/26.
//

import SwiftUI

struct CustomerInfoSection: View {
    let order: Orders
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Customer Info")
                .font(.title3.weight(.bold))
            
            RowField(title: "Name: ", value: order.customer?.name ?? "-")
            RowField(title: "Phone: ", value: order.customer?.phone ?? "-")
            RowField(title: "Address: ", value: order.address ?? "-")
            RowField(title: "Bank Account: ", value: order.customer?.bankAccount ?? "-")
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(10)
    }
}
