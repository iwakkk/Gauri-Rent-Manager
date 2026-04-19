//
//  Products.swift
//  RentManager
//
//  Created by Edward Suwandi on 09/02/26.
//

import Foundation
import Supabase

struct Products: Codable, Hashable {
    let id: UUID
    let name: String
    let color: String
    let size: String
    let price: Double
    let stock: Int
    let imageUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case color
        case size
        case price
        case stock
        case imageUrl = "image_url"
    }
}

