//
//  ProductsView.swift
//  RentManager
//
//  Created by Edward Suwandi on 13/04/26.
//

import SwiftUI

struct ProductsView: View {
    var body: some View {
        VStack{
            Text("Hello")
        }
        
    }
//    @State private var products: [Products] = []
//    @State private var showAddSheet = false
//    @State private var selectedProduct: Products?
//    @State private var viewModel = NewBookingViewModel()
//    var body: some View {
//        NavigationStack {
//            
//            List {
//                ForEach(viewModel.allProducts, id: \.self) { product in
//                    ProductRow(product: product)
//                        .onTapGesture {
//                            selectedProduct = product
//                        }
//                }
//                .onDelete(perform: deleteProduct)
//            }
//            .navigationTitle("Products")
//            .toolbar {
//                Button {
//                    showAddSheet = true
//                } label: {
//                    Image(systemName: "plus")
//                }
//            }
//            .task {
//                await viewModel.loadProducts()
//            }
//            
//            // ADD PRODUCT
//            .sheet(isPresented: $showAddSheet) {
//                AddEditProductView(mode: .add) { newProduct in
//                    products.append(newProduct)
//                }
//            }
//            
//            // EDIT PRODUCT
////            .sheet(item: $selectedProduct) { product in
////                AddEditProductView(mode: .edit(product)) { updatedProduct in
////                    
////                    if let index = products.firstIndex(where: { $0.id == updatedProduct.id }) {
////                        products[index] = updatedProduct
////                    }
////                }
////            }
//        }
//    }
//    
//    // MARK: - DELETE
//    func deleteProduct(at offsets: IndexSet) {
//        products.remove(atOffsets: offsets)
//    }
//}
//
//struct AddEditProductView: View {
//    
//    enum Mode {
//        case add
//        case edit(Products)
//    }
//    
//    let mode: Mode
//    let onSave: (Products) -> Void
//    
//    @Environment(\.dismiss) var dismiss
//    
//    @State private var name = ""
//    @State private var color = ""
//    @State private var size = ""
//    @State private var price = ""
//    @State private var stock = ""
//    
//    var body: some View {
//        NavigationStack {
//            VStack(spacing: 16) {
//                
//                TextField("Name", text: $name)
//                TextField("Color", text: $color)
//                TextField("Size", text: $size)
//                TextField("Price", text: $price)
//                    .keyboardType(.decimalPad)
//                TextField("Stock", text: $stock)
//                    .keyboardType(.numberPad)
//                
////                Button("Save") {
////                    let product = Products(
////                        id: UUID(),
////                        name: name,
////                        color: color,
////                        size: size,
////                        price: Double(price) ?? 0,
////                        total_stock: Int(stock) ?? 0
////                    )
////                    
////                    onSave(product)
////                    dismiss()
////                }
////                .buttonStyle(.borderedProminent)
//                
//                Spacer()
//            }
//            .padding()
//            .navigationTitle(modeTitle)
//            .onAppear {
//                if case .edit(let product) = mode {
//                    name = product.name
//                    color = product.color
//                    size = product.size
//                    price = "\(product.price)"
//                    stock = "\(product.stock)"
//                }
//            }
//        }
//    }
//    
//    private var modeTitle: String {
//        switch mode {
//        case .add: return "Add Product"
//        case .edit: return "Edit Product"
//        }
//    }
//}
//
//struct ProductRow: View {
//    let product: Products
//    
//    var body: some View {
//        VStack(alignment: .leading, spacing: 4) {
//            Text(product.name)
//                .font(.headline)
//            
//            Text("Color: \(product.color) • Size: \(product.size)")
//                .font(.caption)
//                .foregroundColor(.gray)
//            
//            HStack {
//                Text("Stock: \(product.stock)")
//                Spacer()
//                Text("Rp \(product.price, specifier: "%.0f")")
//            }
//            .font(.subheadline)
//        }
//        .padding(.vertical, 4)
//    }
}
#Preview {
    ProductsView()
}
