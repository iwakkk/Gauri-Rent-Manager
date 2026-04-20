//
//  BookingDetailView.swift
//  RentManager
//
//  Created by Edward Suwandi on 19/02/26.
//

import SwiftUI

struct BookingDetailView: View {
    
    @State var draft: BookingDraft
    var allProducts: [Products]
    
    @Binding var bookingId: UUID?
    @Binding var showOrderSheet: Bool
    
    @State private var showConfirmation = false
    @State private var goToInvoicePage = false
    @State private var showValidationAlert = false
    @State private var viewModel = BookingDetailViewModel()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                
                CustomerSectionView(
                    draft: $draft,
                    customers: viewModel.customers
                )
                
                OrderSectionView(
                    draft: $draft,
                    allProducts: allProducts
                )
                
                RentPeriodSectionView(draft: $draft)
                
                CostSectionView(draft: $draft)
            }
            .padding()
        }
        .navigationTitle("Rent Details")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    if viewModel.isFormValid(draft) {
                        showConfirmation = true
                    } else {
                        showValidationAlert = true
                    }
                } label: {
                    Image(systemName: "chevron.right")
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .alert("Confirmation", isPresented: $showConfirmation) {
            Button("Cancel", role: .cancel) { }
            
            Button("Next to Invoice") {
                
                Task {
                    let invoiceView = InvoiceContentView(
                        draft: draft,
                        bookingId: $bookingId
                    )

                    let pdfURL = PDFGenerator.generate(from: invoiceView)

                    do {
                        if let id = bookingId {
                            try await viewModel.updateBooking(id, draft, pdfURL: pdfURL!)
                            
                        } else {
                            let newId = try await viewModel.createBooking(draft, pdfURL: pdfURL!)
                            bookingId = newId
                        }

                        goToInvoicePage = true

                    } catch {
                        print("❌ error:", error)
                    }
                }
            }
        } message: {
            Text("The booking will be saved and continue to invoice.")
        }
        .alert("Incomplete Form", isPresented: $showValidationAlert) {
            Button("OK", role: .cancel) { }
        }
        .navigationDestination(isPresented: $goToInvoicePage) {
            if let id = bookingId {
                InvoiceView(bookingId: id, showOrderSheet: $showOrderSheet)
            }
            else {
                Text("Booking ID not found")
            }
        }
        .task {
            await viewModel.loadCustomers()
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(AppState())
}
