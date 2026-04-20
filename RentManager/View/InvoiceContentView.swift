//
//  InvoiceContentView.swift
//  RentManager
//
//  Created by Edward Suwandi on 06/03/26.
//


import SwiftUI

struct DisplayOrderItem: Identifiable {
    let id = UUID()
    let name: String
    let color: String
    let size: String
    let quantity: Int
    let subtotal: Double
}

struct InvoiceContentView: View {
    
    var draft: BookingDraft
    @Binding var bookingId: UUID?
    
    var body: some View {

        VStack(spacing: 20) {

//            HeaderSectionView(
////                invoiceNumber: draft.id.uuidString.prefix(8).uppercased()
//            )

            Divider()

            HStack(alignment: .top) {

                BilledToSectionView(
                    customerName: draft.customerName,
                    customerPhone: draft.customerPhone,
                    address: draft.customerAddress
                )

                Spacer()

                PaymentInfoSection(
                    accountNumber: draft.customerBankAccount
                )
            }

            
            HStack {
                DateInfoSectionView(
                    startDate: draft.rentStartDate,
                    endDate: draft.rentEndDate
                )
                
                Spacer()
                
            }
            


            OrderItemsTableView(
                items: draft.items.map {
                    DisplayOrderItem(
                        name: $0.productName,
                        color: $0.color,
                        size: $0.size,
                        quantity: $0.quantity,
                        subtotal: $0.subtotal
                    )
                }
            )

            Spacer()
            
                
                TotalSectionView(
                    subtotal: draft.subtotalAmount,
                    shipping: draft.shippingFee,
                    total: draft.totalAmount
                )
                
            
           
        }
        .padding(40)
        .padding(.bottom,50)
        .frame(width: 595, height: 842)
        .background(Color.white)
        
    }
}

//#Preview {
//    let dummy = BookingDraft(
//        customerName: "Edward",
//        customerPhone: "08123456789",
//        customerAddress: "Surabaya",
//        customerBankAccount: "12345678",
//        rentStartDate: Date(),
//        rentEndDate: Date(),
//        items: [
//            BookingItemDraft(
//                productName: "Kimono Sakura",
//                price: 250000,
//                quantity: 2
//            )
//        ],
//        shippingFee: 50000,
//        deposit: 150000
//    )
//
//    return InvoiceContentView(draft: dummy)
//        .scaleEffect(0.6)
//}
