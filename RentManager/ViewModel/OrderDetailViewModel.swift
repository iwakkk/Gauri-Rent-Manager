//
//  OrderDetailViewModel.swift
//  RentManager
//
//  Created by Edward Suwandi on 18/04/26.
//

import Foundation

@Observable
class OrderDetailViewModel {
    
    var order: Orders
    var items: [OrderItems] = []
    var customers: [Customers] = []
    var selectedCustomer: Customers? = nil
    
    var isLoading = false
    var isUpdating = false
    
    
    private let service = OrderService()
    
    init(order: Orders) {
        self.order = order
    }
    
    // LOAD SINGLE ORDER DETAILS
    func loadOrderItems() async {
        isLoading = true
        do {
            items = try await service.fetchItems(for: order.id)
        } catch {
            print("❌ Failed:", error)
            items = []
        }
        isLoading = false
    }
    
    
    // UPDATE STATUS
    func updateStatus(to status: OrderStatus) async {
        isUpdating = true
        do {
            let currentStatus = order.status
            try await service.updateStatus(
                orderId: order.id,
                status: status
            )
            
            order.status = status
            
        } catch {
            print(error)
        }
        isUpdating = false
    }
    
    // CANCEL ORDER
    func cancelOrder() async {
        isUpdating = true
        do {
            try await service.updateStatus(
                orderId: order.id,
                status: .cancelled
            )
            
            order.status = .cancelled
            
        } catch {
            print(error)
        }
        isUpdating = false
    }
}
