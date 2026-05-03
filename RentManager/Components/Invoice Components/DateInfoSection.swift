//
//  DateInfoSection.swift
//  RentManager
//
//  Created by Edward Suwandi on 06/03/26.
//

import SwiftUI

struct DateInfoSectionView: View {

    var startDate: Date
    var endDate: Date
    var accountNumber: String

    var body: some View {


            VStack(alignment: .leading, spacing: 6) {
                
                Text("Order Details")
                    .font(.system(size: 15, weight: .bold))
                
                Text("Rent Period : ")
                    .font(.system(size: 13, weight: .bold))

                Text("\(startDate.formatted(date: .abbreviated, time: .omitted)) - \( Text(endDate.formatted(date: .abbreviated, time: .omitted)))")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(.black.opacity(0.6))
                
                Text("Customer's Bank Account : ")
                    .font(.system(size: 13, weight: .bold))

                Text("Account: \(accountNumber)")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(.black.opacity(0.6))
            }
            .padding(.bottom)
        
    }
}

#Preview {

    let dummyItems = [
        OrderItemDraft(
            productName: "Evening Dress",
            color: "Red",
            size: "M",
            quantity: 2
//            subtotal: 200_000
        ),
        OrderItemDraft(
            productName: "Wedding Gown",
            color: "White",
            size: "L",
            quantity: 1,
//            subtotal: 500_000
        )
    ]

    let draft = OrderDraft(
        customerName: "Siti Aisyah",
        customerPhone: "08123456789",
        customerAddress: "Surabaya, Indonesia",
        customerBankAccount: "1234567890",
        rentStartDate: Date(),
        rentEndDate: Calendar.current.date(byAdding: .day, value: 3, to: Date())!,
        items: dummyItems,
//        subtotalAmount: 700_000,
        shippingFee: 20_000
//        totalAmount: 720_000
    )

    let business = BusinessProfile(
        id: UUID(),
        email: "contact@gauri.com",
        businessName: "Gauri Label",
        businessPhone: "081234567890",
        businessAddress: "Ruko Royal Residence BS 10 No 57 Surabaya",
        bankName: "BCA",
        bankNumber: "1234567890",
        bankAccountName: "Bella",
        businessImageURL: "https://kbioxzncoznvnpiruexh.supabase.co/storage/v1/object/public/business-image/441062721_3256587361313175_9010771886948205444_n.jpg"
    )

    InvoiceContentView(
        draft: draft,
        orderId: UUID(),
        business: business
    )
    .scaleEffect(0.6)
        .frame(width: 595, height: 842)
}
