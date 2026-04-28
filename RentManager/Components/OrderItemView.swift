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
    
    @State private var showNewProduct = false
    
    var body: some View {
        
        VStack(spacing: 14) {
            
            // MARK: HEADER
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
            
            // MARK: PRODUCT PICKER
            Picker("Product", selection: $item.selectedProduct) {
                
                Text("Select Product")
                    .tag(Optional<Products>.none)
                
                ForEach(allProducts, id: \.id) { product in
                    Text("\(product.name ?? "") - \(product.color ?? "")")
                        .tag(Optional(product))
                }
            }
            .pickerStyle(.menu)
            .onChange(of: item.selectedProduct) { newValue in
                guard let product = newValue else { return }
                
                // auto isi dari catalog
                item.productName = product.name ?? ""
                item.color = product.color ?? ""
                item.price = product.price ?? 0
                item.size = ""
            }
            
            // MARK: ADD NEW PRODUCT
            Button {
                showNewProduct = true
            } label: {
                HStack {
                    Image(systemName: "plus.circle.fill")
                    Text("Add New Product")
                }
                .font(.subheadline)
            }
            
            // MARK: QUANTITY (SATU-SATUNYA INPUT)
            FormFieldRow(
                title: "Quantity",
                text: Binding(
                    get: { String(item.quantity) },
                    set: { item.quantity = Int($0) ?? 1 }
                ),
                keyboard: .numberPad
            )
            .disabled(item.selectedProduct == nil)
            .opacity(item.selectedProduct == nil ? 0.5 : 1)
            
            // MARK: COLOR (READ ONLY)
            FormFieldRow(
                title: "Color",
                text: Binding(
                    get: { item.color },
                    set: { _ in }
                )
            )
            .disabled(true)
            .opacity(item.selectedProduct == nil ? 0.5 : 1)
            
            // MARK: PRICE (READ ONLY)
            FormFieldRow(
                title: "Price",
                text: Binding(
                    get: { String(Int(item.price)) },
                    set: { _ in }
                ),
                keyboard: .numberPad
            )
            .disabled(true)
            .opacity(item.selectedProduct == nil ? 0.5 : 1)
            
            // MARK: SIZE (SELECT ONLY)
            if let product = item.selectedProduct {
                
                let sizes = product.size ?? []
                
                if !sizes.isEmpty {
                    Text("Size")
                        .fontWeight(.semibold)
                    
                    HStack(spacing: 12) {
                        
                        ForEach(sizes, id: \.self) { size in
                            
                            Button {
                                item.size = size
                            } label: {
                                HStack(spacing: 6) {
                                    
                                    Text(size)
                                    
                                    Image(systemName: item.size == size
                                          ? "largecircle.fill.circle"
                                          : "circle")
                                        .foregroundColor(.blue)
                                }
                                .padding(.horizontal, 10)
                                .padding(.vertical, 6)
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.gray.opacity(0.2))
                                )
                            }
                        }
                    }
                }
            }
            
            // MARK: SUBTOTAL
            HStack {
                Spacer()
                Text("Subtotal: Rp \(Int(item.subtotal))")
                    .fontWeight(.semibold)
            }
            
            Divider()
        }
        .sheet(isPresented: $showNewProduct) {
            NewProductView(
                viewModel: ProductsViewModel()
            )
        }
    }
}
