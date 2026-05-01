//
//  CostSectionView.swift
//  RentManager
//
//  Created by Edward Suwandi on 19/04/26.
//

import SwiftUI

struct CostSectionView: View {
    
    @Binding var draft: OrderDraft
    
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
                    get: {
                        draft.deposit == 0 ? "" :
                        "Rp \(Int(draft.deposit).formatted(.number.grouping(.automatic)))"
                    },
                    set: { newValue in
                        let numbers = newValue.filter { $0.isNumber }
                        draft.deposit = Double(numbers) ?? 0
                    }
                ),
                keyboard: .numberPad
            )
            
            FormFieldRow(
                title: "Shipping Fee",
                text: Binding(
                    get: {
                        draft.shippingFee == 0 ? "" :
                        "Rp \(Int(draft.shippingFee).formatted(.number.grouping(.automatic)))"
                    },
                    set: { newValue in
                        let numbers = newValue.filter { $0.isNumber }
                        draft.shippingFee = Double(numbers) ?? 0
                    }
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
