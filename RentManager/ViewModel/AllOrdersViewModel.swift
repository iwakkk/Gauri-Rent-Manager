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
    
//    func loadOrders() async {
//        do {
//            let fetchedBookings = try await service.fetchBookings()
//            
//            bookings = fetchedBookings
//                       itemsByBooking.removeAll()
//            
//            for booking in fetchedBookings {
//                let items = try await service.fetchItems(for: booking.id)
//                itemsByBooking[booking.id] = items
//            }
//        }
//        catch {
//            print(error)
//        }
//    }
    
    func loadOrders() async {
        do {
            let fetchedBookings = try await service.fetchBookings()
            
            // tampilkan booking dulu (biar ga kosong)
            self.bookings = fetchedBookings
            self.itemsByBooking.removeAll()
            
            for booking in fetchedBookings {
                Task {
                    do {
                        let items = try await self.service.fetchItems(for: booking.id)
                        
                        // update per booking (fine sekarang)
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
    
//    func loadOrders() async {
//        do {
//            let fetchedBookings = try await service.fetchBookings()
//            
//            var tempItems: [UUID: [BookingItems]] = [:]
//            
//            for booking in fetchedBookings {
//                let items = try await service.fetchItems(for: booking.id)
//                tempItems[booking.id] = items
//            }
//            
//            // 🔥 assign sekali di akhir
//            self.itemsByBooking = tempItems
//            self.bookings = fetchedBookings
//            
//        } catch {
//            print(error)
//        }
//    }
}
