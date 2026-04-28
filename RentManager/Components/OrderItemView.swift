//
//  OrderItemView.swift
//  RentManager
//
//  Created by Edward Suwandi on 19/04/26.
//

import SwiftUI

struct OrderItemView: View {
    
    @Binding var item: BookingItemDraft
    
    var viewModel: ProductsViewModel
    var onDelete: () -> Void
    var canDelete: Bool
    
    @State private var showNewProduct = false
    
    var body: some View {
        
        VStack(spacing: 14) {
            
            // HEADER
            HStack {
                Text("Dress")
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
            HStack {
                // PRODUCT PICKER
                Menu {
                    ForEach(viewModel.products.sorted(by: { $0.name < $1.name }), id: \.id) { product in
                        Button {
                            item.selectedProduct = product
                        } label: {
                            Text("\(product.name) - \(product.color) \(product.isRented ? "(Rented)" : "")")
                        }
                        .disabled(product.isRented)
                    }
                }  label: {
                    HStack {
                        Text(
                            item.selectedProduct == nil
                            ? "Select Product"
                            : "\(item.selectedProduct!.name) - \(item.selectedProduct!.color)"
                        )
                        
                        
                        Image(systemName: "chevron.up.chevron.down")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
                .onChange(of: item.selectedProduct) { newValue in
                    guard let product = newValue else { return }
                    
                    // auto isi dari catalog
                    item.productName = product.name
                    item.color = product.color
                    item.price = product.price
                    item.size = ""
                }
                
                Spacer()
                
                // ADD NEW PRODUCT
                Button {
                    showNewProduct = true
                } label: {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                        Text("Add New Product")
                    }
                    .font(.subheadline)
                }
            }
            
            
            
            // NAME (READ ONLY)
            FormFieldRow(
                title: "Dress",
                text: Binding(
                    get: { item.productName },
                    set: { _ in }
                )
            )
            .disabled(true)
            .opacity(0.5)
            
            // COLOR (READ ONLY)
            FormFieldRow(
                title: "Color",
                text: Binding(
                    get: { item.color },
                    set: { _ in }
                )
            )
            .disabled(true)
            .opacity(0.5)
            
            // QUANTITY (SATU-SATUNYA INPUT)
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
            
            // SIZE (SELECT ONLY)
            if let product = item.selectedProduct {
                
                let sizes = product.size
                
                if !sizes.isEmpty {
                    Text("Size")
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
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
            
            // PRICE (READ ONLY)
            FormFieldRow(
                title: "Price",
                text: Binding(
                    get: { String(Int(item.price)) },
                    set: { _ in }
                ),
                keyboard: .numberPad
            )
            .disabled(true)
            .opacity(0.5)
            
            
            
            // SUBTOTAL
            HStack {
                Spacer()
                Text("Subtotal: Rp \(Int(item.subtotal))")
                    .fontWeight(.semibold)
            }
            
            Divider()
        }
        .sheet(isPresented: $showNewProduct, onDismiss: {
            Task {
                await viewModel.loadProducts()
            }
        }) {
            NewProductView(
                viewModel: viewModel
            )
        }
    }
}
