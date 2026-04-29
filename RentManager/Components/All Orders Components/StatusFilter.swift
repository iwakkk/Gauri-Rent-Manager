//
//  StatusFilter.swift
//  RentManager
//
//  Created by Edward Suwandi on 11/04/26.
//

import SwiftUI

struct StatusFilter: View {
    
    var title: String
    var isSelected: Bool
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline)
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .background(isSelected ? Color.gaurisecondary : Color.gray.opacity(0.15))
                .foregroundColor(isSelected ? .white : .gauriprimary)
                .cornerRadius(20)
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(AppState())
}
