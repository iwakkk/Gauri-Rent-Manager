//
//  OrderConfirmationViewModel.swift
//  RentManager
//
//  Created by Edward Suwandi on 27/02/26.
//

import Foundation

@Observable
class OrderConfirmationViewModel {
    
    var customers: [Customers] = []
    
    private let customerService = CustomerService()
    private let orderService = OrderService()
    
    // Func to create order
    func createOrder(_ draft: OrderDraft) async throws -> UUID {
        let orderId = try await orderService.createOrder(draft)
        
        return orderId
    }

    // Func to update order
    func updateOrder(_ id: UUID, _ draft: OrderDraft) async throws {
        try await orderService.updateOrder(id: id, draft: draft)
        
    }
    
    // Func to upload invoice to supabase
    func uploadInvoice(fileURL: URL, orderId: UUID) async throws {
        _ = try await orderService.uploadInvoice(
            fileURL: fileURL,
            orderId: orderId
        )
    }
    
    // Func to load customers
    func loadCustomers() async {
        do {
            customers = try await customerService.fetchCustomers()
        } catch {
            print(error)
        }
    }
    
    // Func to validate order form
    func isFormValid(_ draft: OrderDraft) -> Bool {
        
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

