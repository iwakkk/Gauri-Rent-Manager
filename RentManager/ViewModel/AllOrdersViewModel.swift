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
    
    var orders: [Orders] = []
    var itemsByOrder: [UUID: [OrderItems]] = [:]
    
    private let service = OrderService()
    
    // Func to load all orders
    func loadOrders() async {
        do {
            let fetchedOrders = try await service.fetchOrders()
            
            self.orders = fetchedOrders
            self.itemsByOrder.removeAll()
            
            for order in fetchedOrders {
                Task {
                    do {
                        let items = try await self.service.fetchItems(for: order.id)
                        
                        self.itemsByOrder[order.id] = items
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
