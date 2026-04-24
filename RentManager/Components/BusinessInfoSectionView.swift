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
                .font(.subheadline)
                .padding(.bottom, 5)
            
            Text(business.businessName)
                .font(.headline)
                .fontWeight(.bold)
            
            Text(business.businessAddress)
                   .lineLimit(nil)
                   .fixedSize(horizontal: false, vertical: true)
            
            Text("Phone: \(business.businessPhone)")
            
            Text("Email: \(business.email)")
            
//            Divider()
//                .padding(.vertical, 6)
//            
//            Text("Bank Info")
//                .font(.caption)
//                .foregroundColor(.secondary)
//            
//            Text(business.bankName)
//                .font(.caption)
//            
//            Text(business.bankNumber)
//                .font(.caption)
//                .fontWeight(.medium)
        }
        .font(.subheadline)
        .frame(maxWidth: .infinity, alignment: .leading)
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
