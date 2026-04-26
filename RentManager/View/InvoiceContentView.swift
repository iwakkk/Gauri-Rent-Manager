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
    let bookingId: UUID
    let business: BusinessProfile?
    
    
    var body: some View {
        if let business = business {
            
            VStack(spacing: 20) {
                
                Spacer()
                
                HeaderSectionView(
                    invoiceNumber: bookingId.uuidString
                        .prefix(8)
                        .uppercased(),
                    business: business
                )
                
                Divider()
                
                HStack(alignment: .top) {
                    
                    BusinessInfoSectionView(business: business)
                    Spacer()
                    
                    BilledToSectionView(
                        customerName: draft.customerName,
                        customerPhone: draft.customerPhone,
                        address: draft.customerAddress
                    )
                    .frame(width: 265)
                    
                }
                .padding(.vertical)
                
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
                
                HStack(alignment: .bottom){
                    VStack(alignment: .leading){
                        
                        DateInfoSectionView(
                            startDate: draft.rentStartDate,
                            endDate: draft.rentEndDate,
                            accountNumber: draft.customerBankAccount
                        )
                        
                       
                        
                        PaymentInfoSection(
                            bankName: business.bankName, bankNumber: business.bankNumber, accountName: business.bankAccountName
                        )
                        
                        
                        
                        
                    }
                    
                    Spacer()
                    TotalSectionView(
                        subtotal: draft.subtotalAmount,
                        shipping: draft.shippingFee,
                        total: draft.totalAmount,
                        deposit: draft.deposit
                    ).frame(width: 265)
                }
                
                
                
            }
            .padding(40)
            .padding(.bottom,50)
            .frame(width: 595, height: 842)
            .background(Color.white)
            
        }
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
