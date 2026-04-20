//
//  CustomerSectionView.swift
//  RentManager
//
//  Created by Edward Suwandi on 19/04/26.
//

import SwiftUI

struct CustomerSectionView: View {
    
    @Binding var draft: BookingDraft
    var customers: [Customers]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            
            Text("Customer Details")
                .font(.title3)
                .fontWeight(.bold)
            
            Picker("Select Customer", selection: $draft.customerId) {

                Text("Select Customer")
                    .tag(UUID?.none)

                ForEach(customers, id: \.id) { customer in
                    Text(customer.name)
                        .tag(Optional(customer.id))
                }
            }
            .onChange(of: draft.customerId) {
                
                guard let id = draft.customerId,
                      let c = customers.first(where: { $0.id == id }) else { return }
                
                draft.customerName = c.name
                draft.customerPhone = c.phone
                draft.customerBankAccount = c.bankAccount
            }
            
            VStack(spacing: 14) {
                FormFieldRow(title: "Customer Name", text: $draft.customerName)
                FormFieldRow(title: "Address", text: $draft.customerAddress)
                FormFieldRow(title: "Phone Number", text: $draft.customerPhone, keyboard: .numberPad)
                FormFieldRow(title: "Bank Account", text: $draft.customerBankAccount, keyboard: .numberPad)
            }
        }
    }
}
