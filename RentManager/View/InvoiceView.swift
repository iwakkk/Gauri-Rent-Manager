//
//  InvoiceView.swift
//  RentManager
//
//  Created by Edward Suwandi on 06/03/26.
//

import SwiftUI

struct InvoiceView: View {
    
    let orderId: UUID
    
    @Binding var showOrderSheet: Bool
    
    @State private var viewModel = InvoiceViewModel()
    
    var body: some View {
        VStack {
            
            if viewModel.isLoading {
                ProgressView("Loading Invoice...")
            }
            else {
                
                // Check invoice in local file
                if let localURL = InvoiceStorage.get(orderId: orderId) {
                    PDFKitView(url: localURL)
                }
                
                // Load invoice from Supabase
                else if let urlString = viewModel.order?.invoiceURL,
                        let url = URL(string: urlString) {
                    PDFKitView(url: url)
                }
                
                // No Invoice Found
                else {
                    Text("No Invoice Found")
                        .foregroundColor(.secondary)
                }
            }
            
            Button("Done") {
                showOrderSheet = false
            }
            .buttonStyle(.borderedProminent)
            .padding()
        }
        .navigationTitle("Invoice")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                
                // Share invoice from local storage
                if let localURL = InvoiceStorage.get(orderId: orderId) {
                    
                    ShareLink(item: localURL) {
                        Image(systemName: "square.and.arrow.up")
                    }
                    
                }
                
                // Share invoice from supabase
                else if let urlString = viewModel.order?.invoiceURL,
                          let url = URL(string: urlString) {
                    
                    ShareLink(item: url) {
                        Image(systemName: "square.and.arrow.up")
                    }
                }
            }
        }
        .task {
            await viewModel.loadOrder(currentId: orderId)
        }
    }
}
