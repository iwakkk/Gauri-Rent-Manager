//
//  OrderItemsTable.swift
//  RentManager
//
//  Created by Edward Suwandi on 06/03/26.
//

import SwiftUI

struct OrderItemsTableView: View {

    var items: [DisplayOrderItem]

    var body: some View {

        VStack {

            HStack {

                Text("Product")
                    .fontWeight(.bold)

                Spacer()

                Text("Qty")
                    .fontWeight(.bold)

                Text("Subtotal")
                    .fontWeight(.bold)
            }

            Divider()

            ForEach(items) { item in

                HStack {

                    Text(item.name)

                    Spacer()

                    Text("\(item.quantity)")

                    Text("Rp \(Int(item.subtotal))")
                }

                Divider()
            }
        }
    }
}
