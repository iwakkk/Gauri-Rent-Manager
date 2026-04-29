//
//  BookingsService.swift
//  RentManager
//
//  Created by Edward Suwandi on 28/02/26.
//

import Foundation
import Supabase

struct BookingUpdate: Encodable {
    let rent_start_date: Date
    let rent_end_date: Date
    let subtotal_amount: Double
    let shipping_fee: Double
    let deposit_amount: Double
    let total_amount: Double
    let invoice_url: String
    let customer_id: UUID
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
                subtotal: $0.subtotal,
                size: $0.size
            )
        }

        try await supabase
            .from("booking_items")
            .insert(items)
            .execute()

        
        return bookingId
    }

    // UPDATE BOOKING WITH THE SAME BOOKING ID
    func updateBooking(id: UUID, draft: BookingDraft) async throws {


        // FIND / UPDATE CUSTOMER
        let customerId = try await findCustomer(draft: draft)

        // UPDATE BOOKING HEADER
        let data = BookingUpdate(
            rent_start_date: draft.rentStartDate,
            rent_end_date: draft.rentEndDate,
            subtotal_amount: draft.subtotalAmount,
            shipping_fee: draft.shippingFee,
            deposit_amount: draft.deposit,
            total_amount: draft.totalAmount,
            invoice_url: "",
            customer_id: customerId,
            address: draft.customerAddress
        )

        try await supabase
            .from("bookings")
            .update(data)
            .eq("id", value: id)
            .execute()

        // REPLACE ITEMS
        try await supabase
            .from("booking_items")
            .delete()
            .eq("booking_id", value: id)
            .execute()

        let items = draft.items.map {
            BookingItems(
                id: UUID(),
                bookingId: id,
                productId: $0.selectedProduct?.id ?? UUID(),
                quantity: $0.quantity,
                subtotal: $0.subtotal,
                size: $0.size
            )
        }

        try await supabase
            .from("booking_items")
            .insert(items)
            .execute()
    }

    // CREATE INVOICE AND UPLOAD TO SUPABASE
    func uploadInvoice(fileURL: URL, bookingId: UUID) async throws -> String {

        let fileName = "invoice-\(bookingId).pdf"
        let data = try Data(contentsOf: fileURL)

        // create file
        try await supabase.storage
            .from("invoices")
            .upload(
                path: fileName,
                file: data,
                options: FileOptions(contentType: "application/pdf", upsert: true)
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
    
    // FETCH ALL BOOKINGS
    func fetchBookings() async throws -> [Bookings] {

        return try await supabase
            .from("bookings")
            .select("*, customers(*)")
            .order("created_at", ascending: false)
            .execute()
            .value
    }
    
    // FETCH SINGLE BOOKING
    func fetchBooking(by id: UUID) async throws -> Bookings {
        
        let response: Bookings = try await supabase
            .from("bookings")
            .select()
            .eq("id", value: id.uuidString)
            .single()
            .execute()
            .value
        
        return response
    }
    
    

    // FETCH ITEMS
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
                    is_rented,
                    image_url
                )
            """)
            .eq("booking_id", value: bookingId)
            .execute()
            .value
    }

    // UPDATE STATUS
    func updateStatus(bookingId: UUID, status: BookingStatus) async throws {

        try await supabase
            .from("bookings")
            .update([
                "status": status.rawValue
            ])
            .eq("id", value: bookingId)
            .execute()
    }

    // UPDATE PRODUCT STATUS TO RENTED
    func markProductsAsRented(bookingId: UUID) async throws {

        let items: [BookingItems] = try await supabase
            .from("booking_items")
            .select()
            .eq("booking_id", value: bookingId)
            .execute()
            .value

        let productIds = items.map { $0.productId }

        guard !productIds.isEmpty else { return }

        try await supabase
            .from("products")
            .update([
                "is_rented": true
            ])
            .in("id", values: productIds)
            .execute()
    }
    
    // UPDATE PRODUCT STATUS TO NOT RENTED
    func releaseProducts(bookingId: UUID) async throws {

        let items: [BookingItems] = try await supabase
            .from("booking_items")
            .select()
            .eq("booking_id", value: bookingId)
            .execute()
            .value

        let productIds = items.map { $0.productId }

        guard !productIds.isEmpty else { return }

        try await supabase
            .from("products")
            .update([
                "is_rented": false
            ])
            .in("id", values: productIds)
            .execute()
    }
    
    // CUSTOMER
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
