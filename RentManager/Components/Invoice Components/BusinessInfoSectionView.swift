//
//  BusinessInfoSectionView.swift
//  RentManager
//
//  Created by Edward Suwandi on 21/04/26.
//

import SwiftUI

struct BusinessInfoSectionView: View {
    
    let business: BusinessProfile
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            
            Text("Company Profile")
                .font(.system(size: 13, weight: .bold))
                .foregroundColor(.black)
            
            Text(business.businessName)
            
            Text(business.businessAddress)
                   .lineLimit(nil)
                   .fixedSize(horizontal: false, vertical: true)
            
            Text("Phone: \(business.businessPhone)")
            
            Text("Email: \(business.email)")
        }
        .font(.system(size: 12, weight: .semibold))
        .foregroundColor(.black.opacity(0.6))
        .frame(maxWidth: .infinity, alignment: .leading)
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
        orderId: UUID(),
        business: business
    )
    .scaleEffect(0.6)
        .frame(width: 595, height: 842)
}
