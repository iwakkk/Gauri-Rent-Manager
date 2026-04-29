//
//  InvoiceViewModel.swift
//  RentManager
//
//  Created by Edward Suwandi on 19/04/26.
//

import Foundation
import SwiftUI


@Observable
class InvoiceViewModel {
    
    var booking: Bookings?
    var isLoading = true
    var errorMessage: String?
    
    private let service = BookingsService()
    
    // MARK: - Load single booking
    func loadBooking(currentId: UUID) async {
        isLoading = true
        errorMessage = nil
        
        defer { isLoading = false }
        
        do {
            self.booking = try await service.fetchBooking(by: currentId)
            
            if booking == nil {
                errorMessage = "Booking tidak ditemukan"
            }
            
        } catch {
            errorMessage = error.localizedDescription
            print("error loading booking:", error)
        }
    }
}
