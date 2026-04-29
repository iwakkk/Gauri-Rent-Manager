//
//  OrderConfirmationViewModel.swift
//  RentManager
//
//  Created by Edward Suwandi on 27/02/26.
//

import Foundation

@Observable
class OrderConfirmationViewModel {
    
    var customers: [Customers] = []
    
    private let customerService = CustomerService()
    private let bookingService = BookingsService()
    
    // CREATE BOOKING
    func createBooking(_ draft: BookingDraft) async throws -> UUID {
        let bookingId = try await bookingService.createBooking(draft)
        
        return bookingId
    }

    // UPDATE BOOKING
    func updateBooking(_ id: UUID, _ draft: BookingDraft) async throws {
        try await bookingService.updateBooking(id: id, draft: draft)
        
    }
    
    // UPLOAD INVOICE
    func uploadInvoice(fileURL: URL, bookingId: UUID) async throws {
        _ = try await bookingService.uploadInvoice(
            fileURL: fileURL,
            bookingId: bookingId
        )
    }
    
    // LOAD CUSTOMER
    func loadCustomers() async {
        do {
            customers = try await customerService.fetchCustomers()
        } catch {
            print(error)
        }
    }
    
    
    // VALIDATE BOOKING FORM
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

