//
//  OrderItemView.swift
//  RentManager
//
//  Created by Edward Suwandi on 19/04/26.
//

import SwiftUI

struct OrderItemView: View {
    
    @Binding var item: OrderItemDraft
    
    var viewModel: ProductsViewModel
    var onDelete: () -> Void
    var canDelete: Bool
    
    let count: Int
    
    @State private var showNewProduct = false
    
    var body: some View {
        
        VStack(spacing: 14) {
            
            // HEADER
            HStack {
                Text("Item(s) \(count)")
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
            HStack{
                // PRODUCT PICKER
                Menu {
                    ForEach(viewModel.products.sorted(by: { $0.name < $1.name }), id: \.id) { product in
                        Button {
                            item.selectedProduct = product
                        } label: {
                            Text("\(product.name) - \(product.color)")
                        }
                    }
                } label: {
                    HStack(spacing: 8) {
                        Image(systemName: "tshirt.fill")
                            .font(.caption)
                            .foregroundColor(.white)
                        
                        Text(
                            item.selectedProduct == nil
                            ? "Select Product"
                            : "\(item.selectedProduct!.name) - \(item.selectedProduct!.color)"
                        )
                        .font(.caption)
                        .foregroundColor(.white)
                        
                        
                        Spacer()
                        
                        Image(systemName: "chevron.down")
                            .font(.caption2)
                            .foregroundColor(.gray)
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 10)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.gauriprimary)
                    )
                    .foregroundColor(.white)
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
                    HStack(spacing: 6) {
                        Image(systemName: "plus.circle.fill")
                            .font(.caption)
                        
                        Text("Add New")
                            .font(.caption)
                            .fontWeight(.medium)
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 8)
                    .background(
                        Capsule()
                            .fill(Color.gauriprimary.opacity(0.15))
                    )
                    .foregroundStyle(Color.gauriprimary)
                }
            }

            Text("Product Info")
                .font(.caption)
                .foregroundColor(.gray)
                .frame(maxWidth: .infinity, alignment: .leading)

            VStack(spacing: 10) {
                // NAME (READ ONLY)
                FormFieldRow(
                    title: "Dress",
                    text: Binding(
                        get: {
                            if item.productName.isEmpty {
                                return ""
                            }
                            return "\(item.productName) - \(item.color)"
                        },
                        set: { _ in }
                    )
                )
                // PRICE (READ ONLY)
                FormFieldRow(
                    title: "Price per Item",
                    text: Binding(
                        get: {
                            "Rp \(Int(item.price).formatted(.number.grouping(.automatic)))"
                        },
                        set: { _ in }
                    )
                )
            }
            .disabled(true)
            .opacity(0.5)
            
            Divider()
            
            Text("Fill Required Details")
                            .font(.caption)
                            .foregroundColor(.gray)
                            .frame(maxWidth: .infinity, alignment: .leading)
            
            // QUANTITY
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
            
            
            // SIZE (SELECTABLE)
            Text("Size")
                .font(.subheadline)
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundColor(item.selectedProduct == nil ? .secondary : .primary)
            
            HStack(spacing: 12) {
                
                let sizes = ["XS", "S", "M", "L", "XL"]
                
                ForEach(sizes, id: \.self) { size in
                    
                    Button {
                        item.size = size
                    } label: {
                        
                        HStack(spacing: 6) {
                            
                            Text(size)
                                .font(.caption)
                                
                            Image(systemName: item.size == size
                                  ? "checkmark.circle.fill"
                                  : "circle")
                            .foregroundColor(.white)
                        }
                        
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.gauriprimary)
                        )
                        .foregroundColor(.white)
                    }
                    .disabled(item.selectedProduct == nil)
                    .opacity(item.selectedProduct == nil ? 0.5 : 1)
                    .buttonStyle(.plain)
                }
            }
            
            // SUBTOTAL
            HStack {
                Spacer()
                Text("Total Price: Rp \(Int(item.subtotal))")
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
