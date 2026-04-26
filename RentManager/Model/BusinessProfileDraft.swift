//
//  BusinessProfileDraft.swift
//  RentManager
//
//  Created by Edward Suwandi on 24/04/26.
//

import Foundation
import Supabase

struct BusinessProfileDraft: Codable{
    var name: String
    var phone: String
    var address: String
    var email: String
    
    var bankName: String
    var bankNumber: String
    var bankAccountName: String
}
