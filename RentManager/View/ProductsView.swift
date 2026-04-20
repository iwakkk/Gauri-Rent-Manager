//
//  ProductsView.swift
//  RentManager
//
//  Created by Edward Suwandi on 13/04/26.
//

import SwiftUI

struct ProductsView: View {
    
    @State private var viewModel = ProductsViewModel()
    
    @State private var name = ""
    @State private var color = ""
    @State private var size = ""
    @State private var price = ""
    @State private var stock = ""
    
    @State private var editingProduct: Products?
    
    var body: some View {
        NavigationStack {
            
            VStack(spacing: 16) {
                
                // MARK: INPUT FORM (INLINE)
                VStack(spacing: 12) {
                    
                    TextField("Name", text: $name)
                        .textFieldStyle(.roundedBorder)
                    
                    TextField("Color", text: $color)
                        .textFieldStyle(.roundedBorder)
                    
                    TextField("Size", text: $size)
                        .textFieldStyle(.roundedBorder)
                    
                    TextField("Price", text: $price)
                        .keyboardType(.decimalPad)
                        .textFieldStyle(.roundedBorder)
                    
                    TextField("Stock", text: $stock)
                        .keyboardType(.numberPad)
                        .textFieldStyle(.roundedBorder)
                    
                    Button {
                        Task {
                            await saveProduct()
                        }
                    } label: {
                        Text(editingProduct == nil ? "Add Product" : "Update Product")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                }
                .padding()
                
                Divider()
                
                // MARK: LIST
                List {
                    ForEach(viewModel.products, id: \.id) { product in
                        
                        VStack(alignment: .leading, spacing: 6) {
                            Text(product.name)
                                .font(.headline)
                            
                            Text("\(product.color) • \(product.size)")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            
                            Text("Stock: \(product.stock)")
                                .font(.caption)
                            
                            Text("Rp \(product.price, specifier: "%.0f")")
                                .font(.caption)
                        }
                        .onTapGesture {
                            loadToForm(product)
                        }
                    }
                    .onDelete(perform: delete)
                }
            }
            .navigationTitle("Products")
            .task {
                await viewModel.loadProducts()
            }
        }
    }
    
    // MARK: - LOAD INTO FORM (EDIT MODE)
    func loadToForm(_ product: Products) {
        editingProduct = product
        
        name = product.name
        color = product.color
        size = product.size
        price = "\(product.price)"
        stock = "\(product.stock)"
    }
    
    // MARK: - SAVE (ADD / UPDATE)
    func saveProduct() async {
        
        guard let priceDouble = Double(price),
              let stockInt = Int(stock) else { return }
        
        let product = Products(
            id: editingProduct?.id ?? UUID(),
            name: name,
            color: color,
            size: size,
            price: priceDouble,
            stock: stockInt,
            imageUrl: nil
        )
        
        if editingProduct == nil {
            await viewModel.addProduct(product)
        } else {
            await viewModel.updateProduct(product)
        }
        
        resetForm()
    }
    
    // MARK: - RESET
    func resetForm() {
        editingProduct = nil
        name = ""
        color = ""
        size = ""
        price = ""
        stock = ""
    }
    
    // MARK: - DELETE
    func delete(at offsets: IndexSet) {
        for index in offsets {
            let product = viewModel.products[index]
            
            Task {
                await viewModel.deleteProduct(id: product.id)
            }
        }
    }
}

#Preview {
    ProductsView()
}
