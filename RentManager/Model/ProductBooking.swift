//
//  ProductBooking.swift
//  RentManager
//
//  Created by Edward Suwandi on 01/05/26.
//

import Foundation

struct ProductBooking: Codable, Identifiable {
    let id = UUID()
    
    let productId: UUID
    let orderId: UUID
    let rentStartDate: Date?
    let rentEndDate: Date?
    let status: String
    
    enum CodingKeys: String, CodingKey {
        case productId = "product_id"
        case orderId = "order_id"
        case rentStartDate = "rent_start_date"
        case rentEndDate = "rent_end_date"
        case status
    }
}

