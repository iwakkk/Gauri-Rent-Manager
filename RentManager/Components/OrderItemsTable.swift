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
                    .frame(maxWidth: .infinity, alignment: .leading)

                Text("Color")
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity)

                Text("Size")
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity)

                Text("Qty")
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity)

                Text("Subtotal")
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }

            Divider()

            ForEach(items) { item in

                HStack {

                    Text(item.name)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    Text("\(item.color)")
                        .frame(maxWidth: .infinity)

                    Text("\(item.size)")
                        .frame(maxWidth: .infinity)

                    Text("\(item.quantity)")
                        .frame(maxWidth: .infinity)

                    Text("Rp \(Int(item.subtotal))")
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }

                Divider()
            }
        }
    }
}
