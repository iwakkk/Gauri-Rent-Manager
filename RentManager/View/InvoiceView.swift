//
//  InvoiceView.swift
//  RentManager
//
//  Created by Edward Suwandi on 06/03/26.
//

import SwiftUI

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
            else if let urlString = viewModel.booking?.invoiceURL,
                    let url = URL(string: urlString) {
                
                PDFKitView(url: url)
                
            } else {
                Text("No Invoice Found")
                    .foregroundColor(.secondary)
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
                if let urlString = viewModel.booking?.invoiceURL,
                   let url = URL(string: urlString) {
                    
                    ShareLink(item: url) {
                        Image(systemName: "square.and.arrow.up")
                    }
                }
            }
            
            ToolbarItem(placement: .topBarLeading) {
                Button("Done") {
                    showOrderSheet = false
                }
            }
        }
        .task {
            await viewModel.loadBooking(currentId: bookingId)
        }
    }
    
    
}
