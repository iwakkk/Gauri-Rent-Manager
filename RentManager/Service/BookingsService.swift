//
//  BookingsService.swift
//  RentManager
//
//  Created by Edward Suwandi on 28/02/26.
//

import Foundation
import Supabase

struct BookingUpdate: Encodable {
    let rent_start_date: String
    let rent_end_date: String
    let subtotal_amount: Double
    let shipping_fee: Double
    let deposit_amount: Double
    let total_amount: Double
    let address: String
}

struct BookingsService {

    // MARK: - CREATE BOOKING
    func createBooking(_ draft: BookingDraft) async throws -> UUID {

        let bookingId = UUID()
        let customerId = try await findCustomer(draft: draft)

        let booking = Bookings(
            id: bookingId,
            rentStartDate: draft.rentStartDate,
            rentEndDate: draft.rentEndDate,
            subtotalAmount: draft.subtotalAmount,
            shippingFee: draft.shippingFee,
            depositAmount: draft.deposit,
            totalAmount: draft.totalAmount,
            status: .unpaid,
            invoiceURL: nil,
            customerId: customerId,
            address: draft.customerAddress
        )

        try await supabase
            .from("bookings")
            .insert(booking)
            .execute()

        let items = draft.items.map {
            BookingItems(
                id: UUID(),
                bookingId: bookingId,
                productId: $0.selectedProduct?.id ?? UUID(),
                quantity: $0.quantity,
                subtotal: $0.subtotal
            )
        }

        try await supabase
            .from("booking_items")
            .insert(items)
            .execute()

        
        return bookingId
    }

    // MARK: update booking with the same booking id
    func updateBooking(id: UUID, draft: BookingDraft) async throws {

        let formatter = ISO8601DateFormatter()

        let data = BookingUpdate(
            rent_start_date: formatter.string(from: draft.rentStartDate),
            rent_end_date: formatter.string(from: draft.rentEndDate),
            subtotal_amount: draft.subtotalAmount,
            shipping_fee: draft.shippingFee,
            deposit_amount: draft.deposit,
            total_amount: draft.totalAmount,
            address: draft.customerAddress
        )

        try await supabase
            .from("bookings")
            .update(data)
            .eq("id", value: id)
            .execute()
    }

    // MARK: create invoice file and upload to supabase
    func uploadInvoice(fileURL: URL, bookingId: UUID) async throws -> String {

        let fileName = "invoice-\(bookingId).pdf"
        let data = try Data(contentsOf: fileURL)

        // create file
        try await supabase.storage
            .from("invoices")
            .upload(
                path: fileName,
                file: data,
                options: FileOptions(contentType: "application/pdf")
            )

        let url = try supabase.storage
            .from("invoices")
            .getPublicURL(path: fileName)

        let urlString = url.absoluteString

        // update database with created file
        try await supabase
            .from("bookings")
            .update([
                "invoice_url": urlString
            ])
            .eq("id", value: bookingId)
            .execute()

        return urlString
    }
    
    // MARK: - FETCH BOOKINGS
    func fetchBookings() async throws -> [Bookings] {

        return try await supabase
            .from("bookings")
            .select("*, customers(*)")
            .order("created_at", ascending: false)
            .execute()
            .value
    }

    // MARK: - FETCH ITEMS
    func fetchItems(for bookingId: UUID) async throws -> [BookingItems] {

        return try await supabase
            .from("booking_items")
            .select("""
                *,
                products (
                    id,
                    name,
                    color,
                    size,
                    price,
                    image_url,
                    stock
                )
            """)
            .eq("booking_id", value: bookingId)
            .execute()
            .value
    }

    // MARK: - UPDATE STATUS
    func updateStatus(bookingId: UUID, status: BookingStatus) async throws {

        try await supabase
            .from("bookings")
            .update([
                "status": status.rawValue
            ])
            .eq("id", value: bookingId)
            .execute()
    }

    // MARK: - CUSTOMER
    func findCustomer(draft: BookingDraft) async throws -> UUID {

        let existing: [Customers] = try await supabase
            .from("customers")
            .select()
            .eq("phone", value: draft.customerPhone)
            .execute()
            .value

        if let customer = existing.first {
            return customer.id
        }

        let id = UUID()

        let newCustomer = Customers(
            id: id,
            name: draft.customerName,
            phone: draft.customerPhone,
            bankAccount: draft.customerBankAccount
        )

        try await supabase
            .from("customers")
            .insert(newCustomer)
            .execute()

        return id
    }


}
