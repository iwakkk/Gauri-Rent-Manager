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
    
    var order: Orders?
    var isLoading = true
    var errorMessage: String?
    
    private let service = OrderService()
    
    // LOAD SINGLE ORDER
    func loadOrder(currentId: UUID) async {
        isLoading = true
        errorMessage = nil
        
        defer { isLoading = false }
        
        do {
            self.order = try await service.fetchOrder(by: currentId)
            
            if order == nil {
                errorMessage = "Order not found"
            }
            
        } catch {
            errorMessage = error.localizedDescription
            print("error loading order:", error)
        }
    }
}
