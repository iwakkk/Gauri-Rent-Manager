//
//  OrderItems.swift
//  RentManager
//
//  Created by Edward Suwandi on 09/02/26.
//

import Foundation

struct OrderItems: Codable, Identifiable{
    let id: UUID
    let orderId: UUID
    let productId: UUID
    let quantity: Int
    let subtotal: Double
    let size: String
    
    var products: Products? = nil 
    
    enum CodingKeys: String, CodingKey {
        case id
        case orderId = "order_id"
        case productId = "product_id"
        case quantity
        case subtotal
        case size
        case products
    }
}
