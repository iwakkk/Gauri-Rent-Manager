//
//  AllRentsViewModel.swift
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
            
            self.bookings = fetchedBookings
            self.itemsByBooking.removeAll()
            
            for booking in fetchedBookings {
                Task {
                    do {
                        let items = try await self.service.fetchItems(for: booking.id)
                        
                        self.itemsByBooking[booking.id] = items
                    } catch {
                        print(error)
                    }
                }
            }
            
        } catch {
            print(error)
        }
    }
}
