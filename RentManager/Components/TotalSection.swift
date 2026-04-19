//
//  TotalSection.swift
//  RentManager
//
//  Created by Edward Suwandi on 06/03/26.
//

import SwiftUI

struct TotalSectionView: View {

    var subtotal: Double
    var shipping: Double
    var total: Double

    var body: some View {

        VStack(alignment: .trailing, spacing: 8) {

            HStack {

                Text("Subtotal")

                Spacer()

                Text("Rp \(Int(subtotal))")
            }

            HStack {

                Text("Shipping")

                Spacer()

                Text("Rp \(Int(shipping))")
            }

            Divider()

            HStack {

                Text("Total")
                    .fontWeight(.bold)

                Spacer()

                Text("Rp \(Int(total))")
                    .fontWeight(.bold)
            }
        }
    }
}

