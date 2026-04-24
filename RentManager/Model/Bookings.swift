//
//  Bookings.swift
//  RentManager
//
//  Created by Edward Suwandi on 09/02/26.
//

import SwiftUI
import Foundation

struct Bookings: Codable, Identifiable, Hashable{
    
    let id: UUID
    
    let rentStartDate: Date?
    let rentEndDate: Date?
    
    let subtotalAmount: Double?
    let shippingFee: Double?
    let depositAmount: Double?
    let totalAmount: Double?
    
    var status: BookingStatus
    let invoiceURL: String?
    let customerId: UUID
    let address: String?
    
    var customer: Customers? = nil
    
    enum CodingKeys: String, CodingKey {
        case id
        case rentStartDate = "rent_start_date"
        case rentEndDate = "rent_end_date"
        case subtotalAmount = "subtotal_amount"
        case shippingFee = "shipping_fee"
        case depositAmount = "deposit_amount"
        case totalAmount = "total_amount"
        case status
        case invoiceURL = "invoice_url"
        case customerId = "customer_id"
        case customer = "customers"
        case address
    }
}

enum BookingStatus: String, CaseIterable, Codable {
    case unpaid = "unpaid"
    case toShip = "to_ship"
    case inUse = "in_use"
    case completed = "completed"
    case cancelled = "cancelled"
    
    var displayName: String {
        switch self {
        case .unpaid: return "Unpaid"
        case .toShip: return "To Ship"
        case .inUse: return "In Use"
        case .completed: return "Completed"
        case .cancelled: return "Cancelled"
        }
    }
    
    var actionTitle: String {
        switch self {
        case .unpaid: return "Confirm Payment"
        case .toShip: return "Ship Item"
        case .inUse: return "Complete Order"
        case .completed, .cancelled: return ""
        }
    }
    
    var hasAction: Bool {
        switch self {
        case .unpaid, .toShip, .inUse:
            return true
        case .completed, .cancelled:
            return false
        }
    }
    
    var nextStatus: BookingStatus? {
        switch self {
        case .unpaid: return .toShip
        case .toShip: return .inUse
        case .inUse: return .completed
        case .completed, .cancelled: return nil
        }
    }
    
    var color: Color {
        switch self {
        case .unpaid: return .orange
        case .toShip: return .yellow
        case .inUse: return .blue
        case .completed: return .green
        case .cancelled: return .red
        }
    }
}
