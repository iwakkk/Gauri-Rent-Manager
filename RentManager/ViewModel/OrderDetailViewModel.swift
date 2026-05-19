//
//  OrderDetailViewModel.swift
//  RentManager
//
//  Created by Edward Suwandi on 18/04/26.
//

import Foundation
import Supabase

struct DressReturn: Codable, Identifiable {
    let id: UUID
    let order_id: UUID
    let is_late: Bool
    let late_days: Int
    let late_fee: Double
    let condition: String
    let damage_fee: Double
    let total_penalty: Double
    let deposit_refund: Double
    let remaining_charge: Double
    let is_returned: Bool
    let return_notes: String
}


@Observable
class OrderDetailViewModel {
    
    var order: Orders
    var items: [OrderItems] = []
    var customers: [Customers] = []
    var selectedCustomer: Customers? = nil
    var returnData: DressReturn?
    
    var isLoading = false
    var isUpdating = false
    
    
    private let service = OrderService()
    
    init(order: Orders) {
        self.order = order
    }
    
    // Func to load single order details
    func loadOrderItems() async {
        isLoading = true
        do {
            items = try await service.fetchItems(for: order.id)
        } catch {
            print("Failed:", error)
            items = []
        }
        isLoading = false
    }
    
    func fetchDressReturn(orderId: UUID) async {
        do {
            let response = try await supabase
                .from("dress_returns")
                .select("*")
                .eq("order_id", value: orderId.uuidString)
                .limit(1)
                .execute()

            print("RAW:", String(data: response.data, encoding: .utf8) ?? "")

            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601

            let data = try decoder.decode([DressReturn].self, from: response.data)

            await MainActor.run {
                self.returnData = data.first  
            }

        } catch {
            print("❌ Fetch dress return error:", error)

            await MainActor.run {
                self.returnData = nil
            }
        }
    }
    
    // Func to update status
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
    
    // Func to cancel order
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
