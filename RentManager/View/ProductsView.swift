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
            VStack {
                Title(title: "Products",
                      actionIcon: "plus.circle.fill", actionTap: {showNewProductSheet = true}
                )
                
                VStack {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(viewModel.products.sorted(by: { $0.name < $1.name }), id: \.id) { product in
                                
                                let ranges = viewModel.bookedRanges[product.id] ?? []
                                
                                ProductCard(product: product, bookedRanges: ranges, recoveryRanges: viewModel.recoveryRanges[product.id] ?? [])
                                    .padding(.horizontal)
                                    .onTapGesture {
                                        selectedProduct = product
                                    }
                            }
                        }
                    }
                }
                .padding(.vertical)
                .background(Color.gauribackground.ignoresSafeArea())
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
    }
}

#Preview {
    ContentView()
        .environmentObject(AppState())
}
