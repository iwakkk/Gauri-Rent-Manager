//
//  ReturnInspectionView.swift
//  RentManager
//
//  Created by Edward Suwandi on 19/05/26.
//

import SwiftUI

struct ReturnInspectionView: View {
    
    let orders: Orders
    let items: [OrderItems]
    var onComplete: () -> Void
    
    @Environment(\.dismiss) var dismiss
    @State private var viewModel = ReturnInspectionViewModel()
    
    // MARK: - INPUT
    @State private var isReturned = true
    @State private var hasLateReturn = false
    @State private var hasDamage = false
    
    @State private var lateDays = ""
    @State private var lateFee = ""
    @State private var damageFee = ""
    @State private var notes = ""
    
    @State private var availableAgainDate = Date()
    @State private var showConfirmDialog = false
    
    // MARK: - CALC
    var deposit: Double { orders.depositAmount ?? 0 }
    var parsedLateFee: Double { Double(lateFee) ?? 0 }
    var parsedDamageFee: Double { Double(damageFee) ?? 0 }
    
    var totalPenalty: Double {
        parsedLateFee + parsedDamageFee
    }
    
    var refund: Double {
        isReturned ? max(deposit - totalPenalty, 0) : 0
    }
    
    var remainingCharge: Double {
        isReturned ? max(totalPenalty - deposit, 0) : deposit
    }
    
    var hasIssue: Bool {
        !isReturned || hasLateReturn || hasDamage
    }
    
    var condition: String {
        if !isReturned { return "Missing" }
        if hasLateReturn && hasDamage { return "Late + Damaged" }
        if hasLateReturn { return "Late" }
        if hasDamage { return "Damaged" }
        return "Good"
    }
    
    var body: some View {
        NavigationStack {
            VStack{
                
                Form {
                    
                    // 🔥 ITEMS CONTEXT
                    Section("Items Being Processed") {
                        ForEach(items) { item in
                            VStack(alignment: .leading, spacing: 4) {
                                Text(item.products?.name ?? "-")
                                    .font(.headline)
                                
                                Text("Qty \(item.quantity) • Size \(item.size)")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    
                    // RETURN STATUS
                    Section("Return Status") {
                        Toggle("Dress returned?", isOn: $isReturned)
                    }
                    
                    // ONLY IF RETURNED
                    if isReturned {
                        
                        Section("Late Return") {
                            Toggle("Late return?", isOn: $hasLateReturn)
                            
                            if hasLateReturn {
                                TextField("Late Days", text: $lateDays)
                                    .keyboardType(.numberPad)
                                
                                TextField("Late Fee", text: $lateFee)
                                    .keyboardType(.numberPad)
                            }
                        }
                        
                        Section("Damage") {
                            Toggle("Damage found?", isOn: $hasDamage)
                            
                            if hasDamage {
                                TextField("Damage Fee", text: $damageFee)
                                    .keyboardType(.numberPad)
                            }
                        }
                    }
                    
                    // NOTES
                    Section("Notes") {
                        TextField("Optional notes", text: $notes, axis: .vertical)
                    }
                    
                    // 🔥 FIX: ONLY SHOW WHEN ISSUE EXISTS
                    if hasIssue {
                        Section("Availability") {
                            
                            DatePicker(
                                "Available again",
                                selection: $availableAgainDate,
                                in: Date()...,
                                displayedComponents: .date
                            )
                            
                            Text("Required for repair / replacement handling")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    // SUMMARY
                    Section("Summary") {
                        
                        HStack {
                            Text("Deposit")
                            Spacer()
                            Text("Rp \(Int(deposit))")
                        }
                        
                        if isReturned {
                            
                            HStack {
                                Text("Penalty")
                                Spacer()
                                Text("Rp \(Int(totalPenalty))")
                            }
                            
                            HStack {
                                Text("Refund")
                                Spacer()
                                Text("Rp \(Int(refund))")
                                    .foregroundColor(.green)
                            }
                            
                            HStack {
                                Text("Remaining Charge")
                                Spacer()
                                Text("Rp \(Int(remainingCharge))")
                                    .foregroundColor(.red)
                            }
                            
                        } else {
                            
                            HStack {
                                Text("Penalty")
                                Spacer()
                                Text("FULL DEPOSIT FORFEITED")
                                    .foregroundColor(.red)
                            }
                        }
                    }
                }
            }
            .background(Color.gauribackground.ignoresSafeArea())
            .navigationTitle("Return Inspection")
            .alert("Confirm Return", isPresented: $showConfirmDialog) {

                Button("Cancel", role: .cancel) {}

                Button("Confirm", role: .destructive) {
                    Task {
                        let payload = DressReturnInsert(
                            order_id: orders.id.uuidString,
                            is_returned: isReturned,
                            is_late: hasLateReturn,
                            late_days: Int(lateDays) ?? 0,
                            late_fee: parsedLateFee,
                            damage_fee: parsedDamageFee,
                            condition: condition,
                            total_penalty: totalPenalty,
                            deposit_refund: refund,
                            remaining_charge: remainingCharge,
                            return_notes: notes,
                            available_again_date: hasIssue ? availableAgainDate : Date()
                        )

                        await viewModel.insertReturnRecord(payload)
                        onComplete()
                        dismiss()
                    }
                }

            } message: {
                Text("""
                Condition: \(condition)

                Penalty: Rp \(Int(totalPenalty))
                Refund: Rp \(Int(refund))
                """)
            }
            .toolbar {
                
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Complete") {
                        showConfirmDialog = true
                    }
                }
            }
            
        }
        
    }
    
}


//#Preview {
//    
//    ReturnInspectionView(
//        orders: Orders(
//            id: UUID(),
//            rentStartDate: Date(),
//            rentEndDate: Date().addingTimeInterval(86400 * 4),
//            subtotalAmount: 500000,
//            shippingFee: 20000,
//            depositAmount: 150000,
//            totalAmount: 520000,
//            status: .inUse,
//            invoiceURL: nil,
//            customerId: UUID(),
//            address: "Surabaya"
//        )
//    ) {
//        print("Completed")
//    }
//}
