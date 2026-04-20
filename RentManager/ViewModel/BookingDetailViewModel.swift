//
//  BookingDetailViewModel.swift
//  RentManager
//
//  Created by Edward Suwandi on 27/02/26.
//

import Foundation
import Supabase

@Observable
class BookingDetailViewModel {
    
    var customers: [Customers] = []
    
    private let customerService = CustomerService()
    private let bookingService = BookingsService()
    
    func createBooking(_ draft: BookingDraft, pdfURL: URL) async throws -> UUID {
        let bookingId = try await bookingService.createBooking(draft)
        
        try await uploadInvoice(fileURL: pdfURL, bookingId: bookingId)
        return bookingId
    }

    func updateBooking(_ id: UUID, _ draft: BookingDraft, pdfURL: URL) async throws {
        try await bookingService.updateBooking(id: id, draft: draft)
        
        try await uploadInvoice(fileURL: pdfURL, bookingId: id)
    }
    
    func uploadInvoice(fileURL: URL, bookingId: UUID) async throws {
        _ = try await bookingService.uploadInvoice(
            fileURL: fileURL,
            bookingId: bookingId
        )
    }
    
    func updateInvoiceURL(bookingId: UUID, url: String) async throws {
        
        try await supabase
            .from("bookings")
            .update(["invoice_url": url])
            .eq("id", value: bookingId)
            .execute()
    }
    
    func loadCustomers() async {
        do {
            customers = try await customerService.fetchCustomers()
        } catch {
            print(error)
        }
    }
    
    
    // MARK: Validate Booking Form
    func isFormValid(_ draft: BookingDraft) -> Bool {
        
        if draft.customerName.isEmpty ||
           draft.customerAddress.isEmpty ||
           draft.customerPhone.isEmpty ||
           draft.customerBankAccount.isEmpty {
            return false
        }
        
        for item in draft.items {
            if item.productName.isEmpty ||
               item.color.isEmpty ||
               item.size.isEmpty ||
               item.price <= 0 ||
               item.quantity <= 0 {
                return false
            }
        }
        
        return true
    }
    
    
    
    
}

