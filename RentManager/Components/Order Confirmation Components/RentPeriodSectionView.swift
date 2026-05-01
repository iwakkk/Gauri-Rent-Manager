//
//  RentPeriodSectionView.swift
//  RentManager
//
//  Created by Edward Suwandi on 19/04/26.
//

import SwiftUI

struct RentPeriodSectionView: View {
    
    @Binding var draft: OrderDraft
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            
            Text("Rent Period")
                .font(.title3)
                .fontWeight(.bold)
            
            DatePicker(
                "Start Date",
                selection: $draft.rentStartDate,
                in: Date()..., // ALWAYS STARTS FROM TODAY
                displayedComponents: .date
            )
            .onChange(of: draft.rentStartDate) { newValue in
               // AUTO ADJUST RENT END DATE WHEN RENT START DATE HAS CHANGE
                if draft.rentEndDate < newValue {
                    draft.rentEndDate = newValue
                }
            }
            
            DatePicker(
                "End Date",
                selection: $draft.rentEndDate,
                in: draft.rentStartDate..., // ALWAYS STARTS FROM RENT START DATE
                displayedComponents: .date
            )
        }
    }
}
