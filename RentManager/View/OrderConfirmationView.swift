//
//  OrderConfirmationView.swift
//  RentManager
//
//  Created by Edward Suwandi on 19/02/26.
//

import SwiftUI

struct OrderConfirmationView: View {
    
    @Binding var orderId: UUID?
    @Binding var showOrderSheet: Bool
    
    @State var draft: OrderDraft
    @State private var showConfirmation = false
    @State private var showDateConflictAlert = false
    @State private var goToInvoicePage = false
    @State private var showValidationAlert = false
    @State private var viewModel = OrderConfirmationViewModel()
    @State private var productsViewModel = ProductsViewModel()
    @State private var businessViewModel = BusinessProfileViewModel()
    @State private var conflictMessage: String = ""
    
    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                
                // Customer Section View
                CustomerSectionView(
                    draft: $draft,
                    customers: viewModel.customers
                )
                .padding()
                .background(Color(.white))
                .cornerRadius(16)
                .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
                
                // Product Section View
                OrderSectionView(
                    draft: $draft,
                    viewModel: productsViewModel
                )
                .padding()
                .background(Color(.white))
                .cornerRadius(16)
                .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
                
                // Rent Period Section View
                RentPeriodSectionView(draft: $draft)
                    .padding()
                    .background(Color(.white))
                    .cornerRadius(16)
                    .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
                
                // Cost Section View
                CostSectionView(draft: $draft)
                    .padding()
                    .background(Color(.white))
                    .cornerRadius(16)
                    .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
                
            }
            .padding()
        }
        .onTapGesture {
            hideKeyboard()
        }
        .background(Color.gauribackground.ignoresSafeArea())
        .navigationTitle("Rent Details")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    // Check if all required form is filled
                    if viewModel.isFormValid(draft) {
                        Task {
                            do {
                                // Get the selected product
                                let products = draft.items.compactMap { $0.selectedProduct }

                                // Check product availability
                                let result = productsViewModel.checkConflicts(
                                    products: products,
                                    startDate: draft.rentStartDate,
                                    endDate: draft.rentEndDate
                                )

                                if result.hasConflict {
                                    conflictMessage = result.message
                                    showDateConflictAlert = true
                                    return
                                }

                                showConfirmation = true
                            } catch {
                                print("Error:", error)
                            }
                        }
                    } else {
                        showValidationAlert = true
                    }
                } label: {
                    Image(systemName: "chevron.right")
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .alert("Date not available", isPresented: $showDateConflictAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(conflictMessage)
        }
        .alert("Confirmation", isPresented: $showConfirmation) {
            Button("Cancel", role: .cancel) { }
            Button("Next to Invoice") {
                
                Task {
                    do {
                        
                        // If the id has created, update the order with the same order id
                        if let id = orderId {
                            try await viewModel.updateOrder(id, draft)
                            
                        }
                        // If id has not created create order with the new id
                        else {
                            let newId = try await viewModel.createOrder(draft)
                            orderId = newId
                        }
                        
                        // Change UUID type from optional to non optional, to pass it to Invoice Content View
                        let id = orderId!
                        
                        let invoiceView = InvoiceContentView(
                            draft: draft,
                            orderId: id,
                            business: businessViewModel.business
                        )
                        
                        // Generate PDF
                        guard let pdfURL = PDFGenerator.generate(from: invoiceView) else {
                            print(" Failed generate PDF")
                            return
                        }
                        
                        // Save to local
                        let localURL = try InvoiceStorage.save(fileURL: pdfURL, orderId: id)
                        print(" Saved local:", localURL)
                        
                        // Upload to supabase
                        Task {
                            do {
                                try await viewModel.uploadInvoice(fileURL: pdfURL, orderId: id)
                                print(" Uploaded to Supabase")
                            } catch {
                                print(" Upload failed:", error)
                            }
                        }
                        goToInvoicePage = true
                        
                    } catch {
                        print("error:", error)
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
            if let id = orderId {
                InvoiceView(orderId: id, showOrderSheet: $showOrderSheet)
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
