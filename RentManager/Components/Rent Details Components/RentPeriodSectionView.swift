//
//  RentPeriodSectionView.swift
//  RentManager
//
//  Created by Edward Suwandi on 19/04/26.
//

import SwiftUI

struct RentPeriodSectionView: View {
    
    @Binding var draft: BookingDraft
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            
            Text("Rent Period")
                .font(.title3)
                .fontWeight(.bold)
            
            DatePicker("Start Date", selection: $draft.rentStartDate, displayedComponents: .date)
            DatePicker("End Date", selection: $draft.rentEndDate, displayedComponents: .date)
        }
    }
}
