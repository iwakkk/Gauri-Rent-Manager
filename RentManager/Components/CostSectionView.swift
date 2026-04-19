//
//  CostSectionView.swift
//  RentManager
//
//  Created by Edward Suwandi on 19/04/26.
//

import SwiftUI

struct CostSectionView: View {
    
    @Binding var draft: BookingDraft
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            
            Text("Cost Details")
                .font(.title3)
                .fontWeight(.bold)
            
            HStack {
                Text("Subtotal")
                Spacer()
                Text("Rp \(Int(draft.subtotalAmount))")
            }
            
            FormFieldRow(
                title: "Deposit",
                text: Binding(
                    get: { String(draft.deposit) },
                    set: { draft.deposit = Double($0) ?? 0 }
                ),
                keyboard: .numberPad
            )
            
            FormFieldRow(
                title: "Shipping Fee",
                text: Binding(
                    get: { String(draft.shippingFee) },
                    set: { draft.shippingFee = Double($0) ?? 0 }
                ),
                keyboard: .numberPad
            )
            
            HStack {
                Text("Total").fontWeight(.bold)
                Spacer()
                Text("Rp \(Int(draft.totalAmount))")
                    .fontWeight(.bold)
            }
        }
    }
}
