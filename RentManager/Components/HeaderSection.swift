//
//  HeaderSection.swift
//  RentManager
//
//  Created by Edward Suwandi on 06/03/26.
//

import SwiftUI

struct HeaderSectionView: View {

    var invoiceNumber: String

    var body: some View {

        HStack {

            VStack(alignment: .leading) {

                Text("Rent Manager")
                    .font(.title)
                    .fontWeight(.bold)

                Text("Rental Service")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }

            Spacer()

            VStack(alignment: .trailing) {

                Text("INVOICE")
                    .font(.title2)
                    .fontWeight(.bold)

                Text("Invoice #\(invoiceNumber)")
                    .font(.caption)
            }
        }
    }
}
