//
//  Users.swift
//  RentManager
//
//  Created by Edward Suwandi on 09/02/26.
//

import Foundation
import Supabase

struct Users: Codable, Identifiable, Hashable {
    let id: UUID
    let email: String
    let role: String
}
