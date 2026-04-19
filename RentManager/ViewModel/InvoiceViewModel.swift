//
//  InvoiceViewModel.swift
//  RentManager
//
//  Created by Edward Suwandi on 06/04/26.
//

import Foundation
import Supabase

@Observable
class InvoiceViewModel {
    
    func findCustomer(draft: BookingDraft) async throws -> UUID {

        // check existing customer by phone
        let existing: [Customers] = try await supabase
            .from("customers")
            .select()
            .eq("phone", value: draft.customerPhone)
            .execute()
            .value

        if let customer = existing.first {
            return customer.id
        }

        // create new customer
        let newCustomerId = UUID()

        let newCustomer = Customers(
            id: newCustomerId,
            name: draft.customerName,
            phone: draft.customerPhone,
            bankAccount: draft.customerBankAccount
        )

        try await supabase
            .from("customers")
            .insert(newCustomer)
            .execute()

        return newCustomerId
    }
    
    func saveToDatabase(draft: BookingDraft) async throws -> UUID {
        
        let bookingId = UUID()
        
        // check customer first
        let customerId = try await findCustomer(draft: draft)
        
        let booking = Bookings(
            id: bookingId,
            rentStartDate: draft.rentStartDate,
            rentEndDate: draft.rentEndDate,
            subtotalAmount: draft.subtotalAmount,
            shippingFee: draft.shippingFee,
            depositAmount: draft.deposit,
            totalAmount: draft.totalAmount,
            status: BookingStatus.unpaid,
            invoiceURL: nil,
            customerId: customerId, 
            address: draft.customerAddress
        )
        
        try await supabase
            .from("bookings")
            .insert(booking)
            .execute()
        
        
        // insert booking items
        let items = draft.items.map { item in
            
            BookingItems(
                id: UUID(),
                bookingId: bookingId,
                productId: item.selectedProduct?.id ?? UUID(),
                quantity: item.quantity,
                subtotal: item.subtotal
            )
        }
        
        try await supabase
            .from("booking_items")
            .insert(items)
            .execute()
        
        print("🎉 BOOKING SAVED SUCCESSFULLY:", bookingId)
        return bookingId
    }
    
    func uploadInvoice(fileURL: URL, bookingId: UUID) async throws -> String {
        
        let fileName = "invoice-\(bookingId).pdf"
        
        let data = try Data(contentsOf: fileURL)
        
        try await supabase.storage
            .from("invoices")
            .upload(
                path: fileName,
                file: data,
                options: FileOptions(contentType: "application/pdf")
            )
        
        let publicURL = try supabase.storage
            .from("invoices")
            .getPublicURL(path: fileName)
        
        return publicURL.absoluteString
    }
    
    func updateInvoiceURL(bookingId: UUID, url: String) async throws {
        
        try await supabase
            .from("bookings")
            .update(["invoice_url": url])
            .eq("id", value: bookingId)
            .execute()
    }
    
    func saveBooking(draft: BookingDraft, pdfURL: URL?) async throws -> UUID {
            
            let bookingId = try await saveToDatabase(draft: draft)

            if let pdfURL {
                let invoiceURL = try await uploadInvoice(
                    fileURL: pdfURL,
                    bookingId: bookingId
                )

                try await updateInvoiceURL(
                    bookingId: bookingId,
                    url: invoiceURL
                )
            }

            return bookingId
        }
    
}
