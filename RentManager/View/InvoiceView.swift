//
//  InvoiceView.swift
//  RentManager
//
//  Created by Edward Suwandi on 06/03/26.
//

import SwiftUI

struct InvoiceView: View {
    
    var draft: BookingDraft
    @Binding var showOrderSheet : Bool
    @Binding var bookingId: UUID?
    @State private var pdfURL: URL?
    @State private var viewModel = InvoiceViewModel()
    @State private var allOrdersViewModel = AllOrdersViewModel()
    @State private var isSaving = false
    
    var body: some View {
        
        VStack {
            
            if let pdfURL {
                PDFKitView(url: pdfURL)
            } else {
                ProgressView("Generating Invoice...")
            }
            Button {
                Task {
                    isSaving = true
                    
                    do {
                        let bookingId = try await viewModel.saveBooking(
                            draft: draft,
                            pdfURL: pdfURL
                        )
                        
                        await allOrdersViewModel.loadOrders()
                        showOrderSheet = false
                        
                        print("✅ Saved:", bookingId)
                        
                    } catch {
                        print("❌ Failed:", error)
                    }
                    
                    isSaving = false
                }
            } label: {
                if isSaving {
                    ProgressView()
                } else {
                    Text("Selesai")
                }
            }
            .disabled(isSaving)
            .buttonStyle(.borderedProminent)
            .padding()
        }
        .navigationTitle("Invoice")
        .toolbar {
            
            ToolbarItem(placement: .topBarTrailing) {
                
                if let pdfURL {
                    ShareLink(item: pdfURL) {
                        Image(systemName: "square.and.arrow.up")
                    }
                }
            }
        }
        .task {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                let invoiceView = InvoiceContentView(draft: draft, bookingId: $bookingId)
                pdfURL = PDFGenerator.generate(from: invoiceView)
            }
        }
    }
}
