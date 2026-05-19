//
//  SummarySection.swift
//  RentManager
//
//  Created by Edward Suwandi on 01/05/26.
//

import SwiftUI

struct SummarySection: View {
    let order: Orders
    
//    // return data
    let refund: Double?
    let remainingCharge: Double?
    let condition: String?
    
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
                Text("Total")
                    .font(.body.bold())
                Spacer()
                Text("Rp \(Int(order.totalAmount ?? 0))")
                    .font(.body.bold())
            }
            // RETURN SECTION
            if refund != nil || remainingCharge != nil || condition != nil {
                
                Divider().padding(.vertical)
                
                VStack(alignment: .leading, spacing: 8) {
                    
                    Text("Return Summary")
                        .font(.headline)
                    
                    if let condition {
                        HStack {
                            Text("Condition")
                            Spacer()
                            Text(condition)
                                .foregroundColor(.blue)
                        }
                    }
                    
                    if let refund {
                        HStack {
                            Text("Refund")
                            Spacer()
                            Text("Rp \(Int(refund))")
                                .foregroundColor(.green)
                        }
                    }
                    
                    if let remainingCharge {
                        HStack {
                            Text("Additional Charge")
                            Spacer()
                            Text("Rp \(Int(remainingCharge))")
                                .foregroundColor(.red)
                        }
                    }
                }
            }
            
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(10)
    }
}
