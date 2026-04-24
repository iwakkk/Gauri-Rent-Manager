//
//  OrderItemView.swift
//  RentManager
//
//  Created by Edward Suwandi on 19/04/26.
//

import SwiftUI

struct OrderItemView: View {
    
    @Binding var item: BookingItemDraft
    var allProducts: [Products]
    var onDelete: () -> Void
    var canDelete: Bool
    
    var body: some View {
        
        
        VStack(spacing: 14) {
            
            HStack {
                Text("Product")
                    .fontWeight(.semibold)
                
                Spacer()
                
                if canDelete {
                    Button {
                        onDelete()
                    } label: {
                        Image(systemName: "trash")
                            .foregroundColor(.red)
                    }
                }
            }
            
            Picker("Product", selection: $item.selectedProduct) {
                Text("Select From Catalog").tag(Products?.none)
                
                ForEach(allProducts, id: \.id) { product in
                    Text("\(product.name) - \(product.color)")
                        .tag(Optional(product))
                }
            }
            .onChange(of: item.selectedProduct) { newValue in
                if let product = newValue {
                    item.productName = product.name
                    item.color = product.color
                    item.size = ""
                    item.price = product.price
                }
            }
            .pickerStyle(.menu)
            
            FormFieldRow(title: "Nama Produk", text: $item.productName)
            
            FormFieldRow(
                title: "Quantity",
                text: Binding(
                    get: { String(item.quantity) },
                    set: { item.quantity = Int($0) ?? 1 }
                ),
                keyboard: .numberPad
            )
            
            FormFieldRow(title: "Color", text: $item.color)
            
            
            FormFieldRow(
                title: "Price",
                text: Binding(
                    get: { String(Int(item.price)) },
                    set: { item.price = Double($0) ?? 0 }
                ),
                keyboard: .numberPad
            )
            
            Text("Size")
                .fontWeight(.semibold)
            
            if let product = item.selectedProduct {
                
                
                
                HStack(spacing: 12) {
                    
                    let sizes = product.size ?? []
                    
                    ForEach(sizes, id: \.self) { size in
                        Button {
                            item.size = size
                        } label: {
                            HStack(spacing: 6) {
                                
                                Text(size)
                                    .foregroundColor(.primary)
                                
                                Image(systemName: item.size == size
                                      ? "largecircle.fill.circle"
                                      : "circle")
                                    .foregroundColor(.blue)
                            }
                            .padding(.horizontal, 10)
                            .padding(.vertical, 6)
                        }
                    }
                }
            }
            
            HStack {
                Spacer()
                Text("Subtotal: Rp \(Int(item.subtotal))")
                    .fontWeight(.semibold)
            }
            
            Divider()
        }
    }
}
