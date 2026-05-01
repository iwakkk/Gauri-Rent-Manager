//
//  OrderConfirmationView.swift
//  RentManager
//
//  Created by Edward Suwandi on 19/02/26.
//

import SwiftUI

struct OrderConfirmationView: View {
    
    
    @Binding var bookingId: UUID?
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
        .onTapGesture {
            hideKeyboard()
        }
        .background(Color.gauribackground.ignoresSafeArea())
        .navigationTitle("Rent Details")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    if viewModel.isFormValid(draft) {
                        Task {
                            do {
                                var allMessages: [String] = []
                                var hasConflict = false
                                
                                let formatter = DateFormatter()
                                formatter.dateFormat = "d MMM"
                                formatter.locale = Locale(identifier: "id_ID")
                                
                                for item in draft.items {
                                    guard let product = item.selectedProduct else { continue }
                                    
                                    let ranges = productsViewModel.bookedRanges[product.id] ?? []
                                    
                                    
                                    let conflicts = ranges.filter { range in
                                        let (start, end) = range
                                        
                                        return draft.rentStartDate <= end &&
                                               draft.rentEndDate >= start
                                    }
                                    
                                    if conflicts.isEmpty { continue }
                                    
                                    hasConflict = true
                                    
                                    let scheduleText = ranges.isEmpty
                                    ? "No existing bookings"
                                    : ranges.map { range in
                                        let start = formatter.string(from: range.0)
                                        let end = formatter.string(from: range.1)
                                        return "• \(start) - \(end)"
                                    }.joined(separator: "\n")
                                    
                                    let message = """
                                    \(product.name)

                                    Existing bookings:
                                    \(scheduleText)
                                    """
                                    
                                    allMessages.append(message)
                                }
                                
                                if hasConflict {
                                    
                                    conflictMessage = """
                                    These products are not available:

                                    \(allMessages.joined(separator: "\n\n----------------\n\n"))

                                    Please choose different dates.
                                    """
                                    
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
                        
                        if let id = bookingId {
                            try await viewModel.updateOrder(id, draft)
                            
                        } else {
                            let newId = try await viewModel.createOrder(draft)
                            bookingId = newId
                        }
                        
                        let id = bookingId!
                        
                        let invoiceView = InvoiceContentView(
                            draft: draft,
                            bookingId: id,
                            business: businessViewModel.business
                        )
                        
                        // GENERATE PDF
                        guard let pdfURL = PDFGenerator.generate(from: invoiceView) else {
                            print(" Failed generate PDF")
                            return
                        }
                        
                        // SAVE TO LOCAL
                        let localURL = try InvoiceStorage.save(fileURL: pdfURL, orderId: id)
                        print(" Saved local:", localURL)
                        
                        // UPLOAD TO SUPABASE
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
