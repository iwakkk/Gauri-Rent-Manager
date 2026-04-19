//
//  OrderDetailViewModel.swift
//  RentManager
//
//  Created by Edward Suwandi on 18/04/26.
//

import Foundation

@Observable
class OrderDetailViewModel {
    
    var booking: Bookings
    var items: [BookingItems] = []
    var customers: [Customers] = []
    var selectedCustomer: Customers? = nil
    
    var isLoading = false
    var isUpdating = false
    
    var showToast = false
    var toastMessage = ""
    
    private let service = BookingsService()
    
    init(booking: Bookings) {
        self.booking = booking
    }
    
    // func to load single booking details
    func loadBookingItems() async {
        isLoading = true
        do {
            items = try await service.fetchItems(for: booking.id)
        } catch {
            print("❌ Failed:", error)
            items = []
        }
        isLoading = false
    }
    
    // func to update status
    func updateStatus(to status: BookingStatus) async {
        isUpdating = true
        do {
            try await service.updateStatus(
                bookingId: booking.id,
                status: status
            )
            
            toastMessage = "Status berhasil diupdate"
            showToast = true
            
            booking.status = status
            
        } catch {
            print(error)
        }
        isUpdating = false
    }
    
    // func to cancel the booking
    func cancelBooking() async {
        isUpdating = true
        do {
            try await service.updateStatus(
                bookingId: booking.id,
                status: .cancelled
            )
            
            toastMessage = "Pesanan dibatalkan"
            showToast = true
            
            booking.status = .cancelled
            
        } catch {
            print(error)
        }
        isUpdating = false
    }
}
