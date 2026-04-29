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
    
    
    private let service = BookingsService()
    
    init(booking: Bookings) {
        self.booking = booking
    }
    
    // LOAD SINGLE BOOKING DETAILS
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
    
    // CHECK PRODUCT AVAILIBILITY WHEN UPDATE STATUS
    func hasRentedProductConflict() -> Bool {
        
        for item in items {
            if item.products?.isRented == true {
                return true
            }
        }
        
        return false
    }
    
    // UPDATE STATUS
    func updateStatus(to status: BookingStatus) async {
        isUpdating = true
        do {
            let currentStatus = booking.status
            try await service.updateStatus(
                bookingId: booking.id,
                status: status
            )
            
            if status == .toShip {
                try await service.markProductsAsRented(bookingId: booking.id)
            }
                   
            if status == .completed {
                try await service.releaseProducts(bookingId: booking.id)
            }
            
            booking.status = status
            
        } catch {
            print(error)
        }
        isUpdating = false
    }
    
    // CANCEL BOOKING
    func cancelBooking() async {
        isUpdating = true
        do {
            try await service.updateStatus(
                bookingId: booking.id,
                status: .cancelled
            )
            
            booking.status = .cancelled
            
        } catch {
            print(error)
        }
        isUpdating = false
    }
}
