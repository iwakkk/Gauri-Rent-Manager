//
//  HeaderSection.swift
//  RentManager
//
//  Created by Edward Suwandi on 06/03/26.
//

import SwiftUI

struct HeaderSectionView: View {

    var invoiceNumber: String
    let business : BusinessProfile?
    var body: some View {

        HStack {

            if business?.businessImageURL == nil {
                
                Text("No Logo Found")
                
            } else if
                let url = URL(string: business?.businessImageURL ?? ""),
                let imageData = try? Data(contentsOf: url),
                let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 80, height: 80)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            
            VStack(alignment: .leading) {

                Text(business!.businessName)
                    .font(.system(size: 28, weight: .bold))

                Text("Dress Rental Service")
                    .font(.system(size: 12, weight: .regular))
                    .foregroundColor(.gray)
            }

            Spacer()

            VStack(alignment: .trailing) {

                Text("INVOICE")
                    .font(.system(size: 22, weight: .bold))

                Text("Invoice #\(invoiceNumber)")
                    .font(.system(size: 12, weight: .regular))
            }
        }
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
        businessAddress: "Jl. Raya Surabaya No. 10",
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

