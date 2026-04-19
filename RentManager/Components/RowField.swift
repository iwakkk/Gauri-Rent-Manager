//
//  RowField.swift
//  RentManager
//
//  Created by Edward Suwandi on 12/03/26.
//

import SwiftUI

struct RowField: View {
    
    let title: String
    let value: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            
            Text(title)
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Text(value)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
