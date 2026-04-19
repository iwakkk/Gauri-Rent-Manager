//
//  AllOrdersViewModel.swift
//  RentManager
//
//  Created by Edward Suwandi on 09/02/26.
//

import SwiftUI

@MainActor
@Observable
class AllOrdersViewModel {
    
    var bookings: [Bookings] = []
    var itemsByBooking: [UUID: [BookingItems]] = [:]
    

    private let service = BookingsService()
    
    func loadOrders() async {
        do {
            let fetchedBookings = try await service.fetchBookings()
            
            bookings = fetchedBookings
                       itemsByBooking.removeAll()
            
            for booking in fetchedBookings {
                let items = try await service.fetchItems(for: booking.id)
                itemsByBooking[booking.id] = items
            }
        }
        catch {
            print(error)
        }
    }
    
}
