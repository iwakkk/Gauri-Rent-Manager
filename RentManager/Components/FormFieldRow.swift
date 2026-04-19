//
//  FormFieldRow.swift
//  RentManager
//
//  Created by Edward Suwandi on 25/02/26.
//

import SwiftUI

struct FormFieldRow: View {
    
    let title: String
    @Binding var text: String
    var keyboard: UIKeyboardType = .default
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            
            Text(title)
                .font(.subheadline)
            
            TextField(title, text: $text)
                .padding()
                .keyboardType(keyboard)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                )
        }
    }
}
