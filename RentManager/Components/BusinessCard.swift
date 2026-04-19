//
//  BusinessCard.swift
//  RentManager
//
//  Created by Edward Suwandi on 13/04/26.
//

import SwiftUI

struct BusinessCard: View {
    
    let business: BusinessProfile
    var body: some View {
            VStack(alignment: .leading, spacing: 4) {
                
                Text(business.businessName)
                    .font(.title3.bold())
                
                Text(business.email)
                    .foregroundColor(.secondary)
                
            }
            .padding(.vertical, 6)
        
    }
}

#Preview {
    BusinessCard(business: BusinessProfile(
        id: UUID(),
        email: "test@mail.com",
        businessName: "My Business",
        businessPhone: 812345678,
        businessAddress: "Surabaya",
        bankName: "",
        bankNumber: 0
    ))
}
