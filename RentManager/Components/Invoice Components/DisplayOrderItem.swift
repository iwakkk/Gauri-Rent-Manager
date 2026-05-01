//
//  DisplayOrderItem.swift
//  RentManager
//
//  Created by Edward Suwandi on 01/05/26.
//

import Foundation

struct DisplayOrderItem: Identifiable {
    let id = UUID()
    let name: String
    let color: String
    let size: String
    let quantity: Int
    let subtotal: Double
}
