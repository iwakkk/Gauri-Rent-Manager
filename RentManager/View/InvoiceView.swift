//
//  InvoiceView.swift
//  RentManager
//
//  Created by Edward Suwandi on 06/03/26.
//

import SwiftUI

struct InvoiceView: View {
    
    let bookingId: UUID
    
    @Binding var showOrderSheet: Bool
    
    @State private var viewModel = InvoiceViewModel()
    
    var body: some View {
        
        VStack {
            
            if viewModel.isLoading {
                ProgressView("Loading Invoice...")
            }
            else {
                
                // CHECK LOCAL FILE
                if let localURL = InvoiceStorage.get(orderId: bookingId) {
                    
                    PDFKitView(url: localURL)
                    
                }
                // FALLBACK: LOAD SUPABASE
                else if let urlString = viewModel.order?.invoiceURL,
                        let url = URL(string: urlString) {
                    
                    PDFKitView(url: url)
                    
                }

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
                
                if let localURL = InvoiceStorage.get(orderId: bookingId) {
                    
                    ShareLink(item: localURL) {
                        Image(systemName: "square.and.arrow.up")
                    }
                    
                } else if let urlString = viewModel.order?.invoiceURL,
                          let url = URL(string: urlString) {
                    
                    ShareLink(item: url) {
                        Image(systemName: "square.and.arrow.up")
                    }
                }
            }
        }
        .task {
            await viewModel.loadOrder(currentId: bookingId)
        }
    }
}
