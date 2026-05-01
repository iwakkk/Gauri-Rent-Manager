//
//  CustomerSectionView.swift
//  RentManager
//
//  Created by Edward Suwandi on 19/04/26.
//

import SwiftUI

struct CustomerSectionView: View {
    
    @Binding var draft: OrderDraft
    var customers: [Customers]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            
            Text("Customer Details")
                .font(.title3)
                .fontWeight(.bold)
            
            Menu {
                Button {
                    draft.customerId = nil
                } label: {
                    Text("Select Customer")
                        .foregroundColor(.white)
                }

                ForEach(customers.sorted(by: { $0.name < $1.name }), id: \.id) { customer in
                    Button {
                        draft.customerId = customer.id
                    } label: {
                        Text("\(customer.name) - \(customer.phone)")
                    }
                }
            } label: {
                HStack(spacing: 8) {
                    
                    Image(systemName: "person.fill")
                        .font(.caption)
                        .foregroundColor(.white)
                    
                    Text(
                        draft.customerId.flatMap { id in
                            customers.first(where: { $0.id == id })
                        }
                        .map { "\($0.name) - \($0.phone)" }
                        ?? "Select Customer"
                    )
                    .font(.caption)
                    .foregroundColor(.white)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.down")
                        .font(.caption2)
                        .foregroundColor(.gray)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 10)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.gauriprimary)
                )
                .foregroundColor(.white)
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
                FormFieldRow(title: "Phone Number", text: $draft.customerPhone, keyboard: .numberPad)
                FormFieldRow(title: "Bank Account", text: $draft.customerBankAccount, keyboard: .numberPad)
                FormFieldRow(title: "Address", text: $draft.customerAddress)
            }
        }
    }
}
