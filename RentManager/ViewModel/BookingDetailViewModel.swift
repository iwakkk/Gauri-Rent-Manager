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
    
    func createBooking(_ draft: BookingDraft) async throws -> UUID {
        try await bookingService.createBooking(draft)
    }

    func updateBooking(_ id: UUID, _ draft: BookingDraft) async throws {
        try await bookingService.updateBooking(id: id, draft: draft)
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

