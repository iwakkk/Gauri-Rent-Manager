//
//  Title.swift
//  RentManager
//
//  Created by Edward Suwandi on 09/02/26.
//

import SwiftUI

struct Title: View {
    let title: String
    let buttonAction: (() -> Void)?
    let buttonIcon: String?
    
    var body: some View {
        HStack {
            Text(title)
                .font(.largeTitle.bold())
            
            Spacer()
            
            if let icon = buttonIcon, let action = buttonAction {
                Button(action: action) {
                    Image(systemName: icon)
                        .font(.largeTitle)
                }
            }
        }
        .padding()
    }
}
