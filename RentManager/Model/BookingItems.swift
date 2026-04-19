//
//  BookingItems.swift
//  RentManager
//
//  Created by Edward Suwandi on 09/02/26.
//

import Foundation

struct BookingItems: Codable, Identifiable{
    let id: UUID
    let bookingId: UUID
    let productId: UUID
    let quantity: Int
    let subtotal: Double
    
    var products: Products? = nil 
    
    enum CodingKeys: String, CodingKey {
        case id
        case bookingId = "booking_id"
        case productId = "product_id"
        case quantity
        case subtotal
        case products
    }
}
