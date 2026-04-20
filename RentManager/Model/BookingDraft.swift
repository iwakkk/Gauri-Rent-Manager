//
//  BookingDraft.swift
//  RentManager
//
//  Created by Edward Suwandi on 25/02/26.
//

import Foundation

struct BookingDraft {
    
    var customerId: UUID?
    
    var customerName: String = ""
    var customerPhone: String = ""
    var customerAddress: String = ""
    var customerBankAccount: String = ""
    
    var rentStartDate: Date = Date()
    var rentEndDate: Date = Date()
    
    var items: [BookingItemDraft] = [BookingItemDraft()]
    
    var shippingFee: Double = 0
    var deposit: Double = 0
    
    var subtotalAmount: Double {
        items.reduce(0) { $0 + $1.subtotal }
    }
    
    var totalAmount: Double {
        deposit + subtotalAmount + shippingFee
    }
}
