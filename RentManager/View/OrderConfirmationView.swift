//
//  OrderConfirmationView.swift
//  RentManager
//
//  Created by Edward Suwandi on 19/02/26.
//

import SwiftUI

struct OrderConfirmationView: View {
    
    @State var draft: BookingDraft
    
    @Binding var bookingId: UUID?
    @Binding var showOrderSheet: Bool
    
    @State private var showConfirmation = false
    @State private var goToInvoicePage = false
    @State private var showValidationAlert = false
    @State private var viewModel = OrderConfirmationViewModel()
    @State private var productsViewModel = ProductsViewModel()
    @State private var businessViewModel = BusinessProfileViewModel()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                
                CustomerSectionView(
                    draft: $draft,
                    customers: viewModel.customers
                )
                .padding()
                .background(Color(.white))
                        .cornerRadius(16)
                        .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
                        
                
                OrderSectionView(
                    draft: $draft,
                    viewModel: productsViewModel
                )
                .padding()
                .background(Color(.white))
                        .cornerRadius(16)
                        .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
                        
                RentPeriodSectionView(draft: $draft)
                    .padding()
                    .background(Color(.white))
                            .cornerRadius(16)
                            .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
                            
                CostSectionView(draft: $draft)
                    .padding()
                    .background(Color(.white))
                    .cornerRadius(16)
                    .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
                    
            }
            .padding()
        }
        .background(Color.gauribackground.ignoresSafeArea())
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
                    do {
                        if let id = bookingId {
                            try await viewModel.updateBooking(id, draft)
                            
                        } else {
                            let newId = try await viewModel.createBooking(draft)
                            bookingId = newId
                        }
                        
                        let id = bookingId!
                        
                        let invoiceView = InvoiceContentView(
                            draft: draft,
                            bookingId: id,
                            business: businessViewModel.business
                        )
                        
                        // 1. GENERATE PDF
                        guard let pdfURL = PDFGenerator.generate(from: invoiceView) else {
                            print("❌ Failed generate PDF")
                            return
                        }
                        
                        // 2. SAVE KE LOCAL
                        let localURL = try InvoiceStorage.save(fileURL: pdfURL, bookingId: id)
                        print("✅ Saved local:", localURL)
                        
                        // 3. UPLOAD KE SUPABASE (BACKGROUND)
                        Task {
                            do {
                                try await viewModel.uploadInvoice(fileURL: pdfURL, bookingId: id)
                                print("☁️ Uploaded to Supabase")
                            } catch {
                                print("⚠️ Upload failed:", error)
                            }
                        }
                        
                        // 4. NAVIGATE
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
            await businessViewModel.loadBusinessProfile()
            await viewModel.loadCustomers()
            await productsViewModel.loadProducts()
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(AppState())
}
