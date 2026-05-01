//
//  OrderCard.swift
//  RentManager
//
//  Created by Edward Suwandi on 09/03/26.
//

import SwiftUI

struct OrderCard: View {
    
    let order: Orders
    let items: [OrderItems]?
    
    var firstItem: OrderItems? {
        items?.first
    }
    
    var remainingCount: Int {
        max(items!.count - 1, 0)
    }
    
    var rentPeriod: String {
        guard
            let start = order.rentStartDate,
            let end = order.rentEndDate
        else { return "-" }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM"
        
        return "\(formatter.string(from: start)) - \(formatter.string(from: end))"
    }
    
    var body: some View {
        
        HStack {
            
            VStack(alignment: .leading, spacing: 8) {
                
                // Customer + Status
                HStack {
                    
                    Text(order.customer?.name ?? "Unknown Customer")
                        .font(.subheadline)
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    Text(order.status.displayName)
                        .font(.caption.bold())
                        .foregroundColor(order.status.color)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(
                            order.status.color.opacity(0.15)
                        )
                        .clipShape(Capsule())
                }
                
                // Product + Rent Period
                HStack {
                    if let firstItem = firstItem {
                        Text("\(firstItem.products?.name ?? "-") - \(firstItem.products?.color ?? "-")")
                            .font(.body.bold())
                            .lineLimit(1)
                            .foregroundColor(.gauriprimary)
                    }
                    else {
                        Text("Loading...")
                            .font(.body)
                            .foregroundColor(.gray)
                    }
                    
                    Spacer()
                    
                    Text(rentPeriod)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                // Additional Items
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

    let dummyBooking = Orders(
        id: UUID(),
        rentStartDate: Date(),
        rentEndDate: Calendar.current.date(byAdding: .day, value: 3, to: Date()),
        subtotalAmount: 500000,
        shippingFee: 20000,
        depositAmount: 100000,
        totalAmount: 620000,
        status: OrderStatus.unpaid,
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
        imageUrl: ""
    )

    let dummyItems = [
        OrderItems(
            id: UUID(),
            orderId: dummyBooking.id,
            productId: UUID(),
            quantity: 1,
            subtotal: 250000,
            size: "M",
            products: dummyProduct
        ),
        OrderItems(
            id: UUID(),
            orderId: dummyBooking.id,
            productId: UUID(),
            quantity: 1,
            subtotal: 250000,
            size: "L",
            products: dummyProduct
        )
    ]

    OrderCard(
        order: dummyBooking,
        items: dummyItems
    )
}
