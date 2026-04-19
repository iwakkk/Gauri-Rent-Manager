//
//  BookingItemDraft.swift
//  RentManager
//
//  Created by Edward Suwandi on 25/02/26.
//

import Foundation

struct BookingItemDraft: Identifiable {
    let id = UUID()
    
    var selectedProduct: Products?
    
    var productName: String = ""
    var color: String = ""
    var size: String = ""
    var price: Double = 0
    var quantity: Int = 1
    
    var subtotal: Double {
        guard let product = selectedProduct else { return 0 }
        return Double(quantity) * product.price
    }
}
