//
//  TotalSection.swift
//  RentManager
//
//  Created by Edward Suwandi on 06/03/26.
//

import SwiftUI

struct TotalSectionView: View {

    var subtotal: Double
    var shipping: Double
    var total: Double
    var deposit: Double

    var body: some View {

        VStack(alignment: .trailing, spacing: 8) {

            HStack {

                Text("Subtotal")

                Spacer()

                Text("Rp \(Int(subtotal))")
            }
            
            HStack {

                Text("Deposit")

                Spacer()

                Text("Rp \(Int(deposit))")
            }

            
            HStack {

                Text("Shipping")

                Spacer()

                Text("Rp \(Int(shipping))")
            }

            Divider()

            HStack {

                Text("Total")
                    

                Spacer()

                Text("Rp \(Int(total))")
            }
            .fontWeight(.bold)
        }
        .font(.system(size: 15, weight: .regular))
    }
}

#Preview {

    let dummyItems = [
        BookingItemDraft(
            productName: "Evening Dress",
            color: "Red",
            size: "M",
            quantity: 2
//            subtotal: 200_000
        ),
        BookingItemDraft(
            productName: "Wedding Gown",
            color: "White",
            size: "L",
            quantity: 1,
//            subtotal: 500_000
        )
    ]

    let draft = BookingDraft(
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
        bookingId: UUID(),
        business: business
    )
    .scaleEffect(0.6)
        .frame(width: 595, height: 842)
}
