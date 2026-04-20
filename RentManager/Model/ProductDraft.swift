//
//  ProductDraft.swift
//  RentManager
//
//  Created by Edward Suwandi on 20/04/26.
//

import SwiftUI

struct ProductDraft: Codable, Identifiable {
    var id: UUID
    var name: String
    var color: String
    var size: [String]
    var price: Double = 0
    var isRented: Bool
    var imageUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case color
        case size
        case price
        case isRented = "is_rented"
        case imageUrl = "image_url"
    }
}
