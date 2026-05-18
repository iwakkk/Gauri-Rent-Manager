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
    @State private var showDeleteAlert = false
    
    init(product: Products, viewModel: ProductsViewModel) {
        self.product = product
        self.viewModel = viewModel
        
        _draft = State(initialValue: ProductDraft(
            id: product.id,
            name: product.name,
            color: product.color,
            size: product.size,
            price: product.price,
            imageUrl: product.imageUrl
        ))
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    
                    // Image
                    VStack {
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
                    .frame(width: UIScreen.main.bounds.width - 32)
                    .frame(height: (UIScreen.main.bounds.width - 32) * 4 / 3)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .clipped()
                    .padding(.horizontal)
                    
                    
                    // Form Card
                    VStack(spacing: 16) {
                        
                        FormFieldRow(title: "Product Name", text: $draft.name)
                            .onChange(of: draft.name) { _ in checkChanges() }
                        
                        FormFieldRow(title: "Color", text: $draft.color)
                            .onChange(of: draft.color) { _ in checkChanges() }
                        
                        FormFieldRow(
                            title: "Price",
                            text: Binding(
                                get: {
                                    draft.price == 0 ? "" :
                                    "Rp \(Int(draft.price).formatted(.number.grouping(.automatic)))"
                                },
                                set: { newValue in
                                    let numbers = newValue.filter { $0.isNumber }
                                    draft.price = Double(numbers) ?? 0
                                }
                            ),
                            keyboard: .numberPad
                        )
                        .onChange(of: draft.price) { _ in checkChanges() }
                        
                    }
                    .padding()
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .shadow(color: .black.opacity(0.05), radius: 8, y: 4)
                    .padding(.horizontal)
                    
                }
                .padding(.top, 16)
            }
            .background(Color.gauribackground.ignoresSafeArea())
            .onTapGesture {
                hideKeyboard()
            }
            .navigationTitle("Product Detail")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                
                ToolbarItem(placement: .topBarLeading) {
                    Button("Close") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button(role: .destructive) {
                        showDeleteAlert = true
                    } label: {
                        Image(systemName: "trash")
                            .foregroundColor(Color.red)
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
                                    imageUrl: draft.imageUrl
                                )
                            )
                            dismiss()
                        }
                    }
                    .disabled(!hasChanges)
                    
                }
            }
            
            // Delete Alert
            .alert("Delete this product?", isPresented: $showDeleteAlert) {
                Button("Delete", role: .destructive) {
                    Task {
                        await viewModel.deleteProduct(id: draft.id)
                        dismiss()
                    }
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("This action cannot be undone.")
            }
        }
    }
    
    // Detect changes
    private func checkChanges() {
        hasChanges =
            draft.name != product.name ||
            draft.color != product.color ||
            draft.price != product.price
    }
}
#Preview {
    ContentView()
        .environmentObject(AppState())
}
