//
//  OrderCard.swift
//  RentManager
//
//  Created by Edward Suwandi on 09/03/26.
//

import SwiftUI

struct OrderCard: View {
    
    let booking: Bookings
    let items: [BookingItems]
    
    var firstItem: BookingItems? {
        items.first
    }
    
    var remainingCount: Int {
        max(items.count - 1, 0)
    }
    
    var rentPeriod: String {
        guard
            let start = booking.rentStartDate,
            let end = booking.rentEndDate
        else { return "-" }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM"
        
        return "\(formatter.string(from: start)) - \(formatter.string(from: end))"
    }
    
    var body: some View {
        
        HStack {
            
            VStack(alignment: .leading, spacing: 8) {
                
                // MARK: Row 1 — Customer + Status
                HStack {
                    
                    Text(booking.customer?.name ?? "Unknown Customer")
                        .font(.subheadline)
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    Text(booking.status.displayName)
                        .font(.caption.bold())
                        .foregroundColor(booking.status.color)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(
                            booking.status.color.opacity(0.15)
                        )
                        .clipShape(Capsule())
                }
                
                // MARK: Row 2 — Product + Rent Period
                HStack {
                    
                    Text(firstItem?.products?.name ?? "-")
                        .font(.body.bold())
                        .lineLimit(1)
                        .foregroundColor(.gauriprimary)
                    
                    Spacer()
                    
                    Text(rentPeriod)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                // MARK: Additional Items
                if remainingCount > 0 {
                    Text("+ \(remainingCount) item lainnya")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            }
            .padding(12)
        }
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.black.opacity(0.05), lineWidth: 1)
        )
        .padding(.horizontal)
    }
}
#Preview {

    let dummyBooking = Bookings(
        id: UUID(),
        rentStartDate: Date(),
        rentEndDate: Calendar.current.date(byAdding: .day, value: 3, to: Date()),
        subtotalAmount: 500000,
        shippingFee: 20000,
        depositAmount: 100000,
        totalAmount: 620000,
        status: BookingStatus.unpaid,
        invoiceURL: nil,
        customerId: UUID(uuidString: "6729608b-4829-458b-a710-bd846ad442c0") ?? UUID(),
        address: "kalianyar"
    )

    let dummyProduct = Products(
        id: UUID(),
        name: "Kimono Sakura",
        color: "Pink",
        size: ["M"],
        price: 250000,
        isRented: false,
        imageUrl: ""
    )

    let dummyItems = [
        BookingItems(
            id: UUID(),
            bookingId: dummyBooking.id,
            productId: UUID(),
            quantity: 1,
            subtotal: 250000,
            size: "M",
            products: dummyProduct
        ),
        BookingItems(
            id: UUID(),
            bookingId: dummyBooking.id,
            productId: UUID(),
            quantity: 1,
            subtotal: 250000,
            size: "L",
            products: dummyProduct
        )
    ]

    OrderCard(
        booking: dummyBooking,
        items: dummyItems
    )
}
