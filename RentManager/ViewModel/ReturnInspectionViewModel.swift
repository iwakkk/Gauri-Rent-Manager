//
//  ReturnInspectionViewModel.swift
//  RentManager
//
//  Created by Edward Suwandi on 19/05/26.
//

import Foundation
import Supabase

struct DressReturnInsert: Encodable {
    let order_id: String
    let is_returned: Bool
    let is_late: Bool
    let late_days: Int
    let late_fee: Double
    let damage_fee: Double
    let condition: String
    let total_penalty: Double
    let deposit_refund: Double
    let remaining_charge: Double
    let return_notes: String
    let available_again_date: Date?
}

import Foundation
import Supabase

@Observable
class ReturnInspectionViewModel {
    
    func insertReturnRecord(_ data: DressReturnInsert) async {
        do {
            try await supabase
                .from("dress_returns")
                .insert(data)
                .execute()
            
            print("✅ Return inserted")
            
        } catch {
            print("❌ Insert failed:", error.localizedDescription)
        }
    }
}
