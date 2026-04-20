//
//  ProductsView.swift
//  RentManager
//
//  Created by Edward Suwandi on 13/04/26.
//

import SwiftUI

struct ProductsView: View {
    
    @State private var viewModel = ProductsViewModel()
    @State private var showNewProductSheet = false
    @State private var showProductDetailSheet = false
    @State private var selectedProduct: Products?
    
    var body: some View {
//        NavigationStack{
            VStack {
                Title(title: "Products",
                      buttonAction: {showNewProductSheet = true},
                      buttonIcon: "plus.circle.fill"
                )
                ScrollView {
                    
                    LazyVStack(spacing: 12) {
                        
                        ForEach(viewModel.products, id: \.id) { product in
                            ProductCard(product: product)
                                .padding(.horizontal)
                                .onTapGesture {
                                    selectedProduct = product
                                }
                        }
                    }
                }
                
            }
            .fullScreenCover(item: $selectedProduct) { product in
                ProductDetailView(product: product, viewModel: viewModel)
            }
            .task {
                await viewModel.loadProducts()
            }
            .sheet(isPresented: $showNewProductSheet) {
                NewProductView(viewModel: viewModel)
            }
            
//        }
    }
}
#Preview {
    ProductsView()
}

#Preview {
    ContentView()
        .environmentObject(AppState())
}
