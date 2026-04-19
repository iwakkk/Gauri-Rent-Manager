//
//  BilledToSection.swift
//  RentManager
//
//  Created by Edward Suwandi on 06/03/26.
//

import SwiftUI

struct BilledToSectionView: View {

    var customerName: String
    var customerPhone: String
    var address: String

    var body: some View {

        VStack(alignment: .leading, spacing: 4) {

            Text("Billed To")
                .fontWeight(.bold)

            Text(customerName)

            Text(customerPhone)

            Text(address)
                .font(.caption)
        }
    }
}
