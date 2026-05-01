//
//  InfoRow.swift
//  RentManager
//
//  Created by Edward Suwandi on 01/05/26.
//

import SwiftUI

struct InfoRow: View {
    let icon: String
    let title: String
    let value: String?
    var body: some View {
        HStack {
            Label(title, systemImage: icon)
            Spacer()
            Text(value ?? "-")
                
                .foregroundStyle(.secondary)
        }
        
    }
}
