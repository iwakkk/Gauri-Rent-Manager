//
//  ProductDetailView.swift
//  RentManager
//
//  Created by Edward Suwandi on 20/04/26.
//

import SwiftUI

struct ProductDetailView: View {
    
    let product: Products
    var viewModel: ProductsViewModel
    
    @Environment(\.dismiss) var dismiss
    
    @State private var draft: ProductDraft
    @State private var hasChanges = false
    
    init(product: Products, viewModel: ProductsViewModel) {
        self.product = product
        self.viewModel = viewModel
        
        _draft = State(initialValue: ProductDraft(
            id: product.id,
            name: product.name,
            color: product.color,
            size: product.size,
            price: product.price,
            isRented: product.isRented,
            imageUrl: product.imageUrl
        ))
    }
    
    var body: some View {
        NavigationStack {
            
            ScrollView {
                VStack(spacing: 0) {
                    
                    // MARK: IMAGE HEADER
                    ZStack {
                        
                        if let imageUrl = draft.imageUrl,
                           let url = URL(string: imageUrl) {
                            
                            AsyncImage(url: url) { image in
                                image
                                    .resizable()
                                    .scaledToFill()
                            } placeholder: {
                                Color.gray.opacity(0.2)
                            }
                            
                        } else {
                            Color.gray.opacity(0.2)
                        }
                    }
                    .frame(height: 260)
                    .clipped()
                    
                    
                    // MARK: FORM SECTION
                    VStack(spacing: 16) {
                        
                        FormFieldRow(title: "Product Name", text: $draft.name)
                            .onChange(of: draft.name) { _ in checkChanges() }
                        
                        FormFieldRow(title: "Color", text: $draft.color)
                            .onChange(of: draft.color) { _ in checkChanges() }
                        
                        FormFieldRow(
                            title: "Price",
                            text: Binding(
                                get: { String(draft.price) },
                                set: { draft.price = Double($0) ?? 0 }
                            ),
                            keyboard: .decimalPad
                        )
                        .onChange(of: draft.price) { _ in checkChanges() }
                        
                        Toggle("Is Rented", isOn: $draft.isRented)
                            .onChange(of: draft.isRented) { _ in checkChanges() }
                    }
                    .padding()
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .padding(.top, -20)
                }
            }
            
            // MARK: NAV BAR
            .navigationTitle("Product Detail")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                
                ToolbarItem(placement: .topBarLeading) {
                    Button("Close") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        Task {
                            await viewModel.updateProduct(
                                Products(
                                    id: draft.id,
                                    name: draft.name,
                                    color: draft.color,
                                    size: draft.size,
                                    price: draft.price,
                                    isRented: draft.isRented,
                                    imageUrl: draft.imageUrl
                                )
                            )
                            dismiss()
                        }
                    }
                    .disabled(!hasChanges)
                }
            }
        }
    }
    
    // MARK: CHANGE DETECTION
    private func checkChanges() {
        hasChanges =
            draft.name != product.name ||
            draft.color != product.color ||
            draft.price != product.price ||
            draft.isRented != product.isRented
    }
}
