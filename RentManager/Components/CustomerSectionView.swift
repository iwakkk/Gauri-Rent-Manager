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
            
            Picker("Select Customer", selection: Binding(
                get: {
                    customers.first {
                        $0.name == draft.customerName &&
                        $0.phone == draft.customerPhone &&
                        $0.bankAccount == draft.customerBankAccount
                    }
                },
                set: { newValue in
                    if let c = newValue {
                        draft.customerName = c.name
                        draft.customerPhone = c.phone
                        draft.customerBankAccount = c.bankAccount
                    }
                }
            )) {
                Text("Select Customer").tag(Customers?.none)
                
                ForEach(customers, id: \.id) { customer in
                    Text(customer.name)
                        .tag(Optional(customer))
                }
            }
            .pickerStyle(.menu)
            
            VStack(spacing: 14) {
                FormFieldRow(title: "Customer Name", text: $draft.customerName)
                FormFieldRow(title: "Address", text: $draft.customerAddress)
                FormFieldRow(title: "Phone Number", text: $draft.customerPhone, keyboard: .numberPad)
                FormFieldRow(title: "Bank Account", text: $draft.customerBankAccount, keyboard: .numberPad)
            }
        }
    }
}
