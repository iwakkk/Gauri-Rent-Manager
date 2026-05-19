//
//  OrderDetailView.swift
//  RentManager
//
//  Created by Edward Suwandi on 10/03/26.
//

import SwiftUI

struct OrderDetailView: View {
    
    @State var viewModel: OrderDetailViewModel
    @State var productsViewModel = ProductsViewModel()
    @State private var showInvoiceSheet = false
    @State private var showCancelAlert = false
    @State private var showConfirmAlert = false
    @State private var showRentedAlert = false
    @State private var rentedMessage = ""
    @State private var showReturnSheet = false
    
    @Binding var selectedTab: OrderStatus?
    @Environment(\.dismiss) var dismiss
    
    var rentPeriod: String {
        guard let start = viewModel.order.rentStartDate, let end = viewModel.order.rentEndDate else { return "-" }
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy"
        return "\(formatter.string(from: start)) - \(formatter.string(from: end))"
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                
                // Customer Info Section
                CustomerInfoSection(order: viewModel.order)
                
                // Rent Detail Section
                RentDetailSection(
                       order: viewModel.order,
                       rentPeriod: rentPeriod
                   )
                   
                // Order Items Section
               OrderItemsSection(
                   items: viewModel.items,
                   isLoading: viewModel.isLoading
               )
                // Summary Section
                SummarySection(
                    order: viewModel.order,
                    refund: viewModel.returnData?.deposit_refund,
                    remainingCharge: viewModel.returnData?.remaining_charge,
                    condition: viewModel.returnData?.condition
                )
                
                // Invoice
                if viewModel.order.invoiceURL != nil {
                    
                    Button {
                        showInvoiceSheet = true
                    } label: {
                        HStack {
                            Image(systemName: "doc.text")
                            Text("View Invoice")
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.gauriprimary)
                        .foregroundColor(.white)
                        .cornerRadius(30)
                    }
                    
                } else {
                    Text("Invoice is not available")
                        .foregroundColor(.secondary)
                }
                
                Spacer()
            }
            .padding()
            
            
        }
        .background(Color.gauribackground.ignoresSafeArea())
        .toolbar {
            
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showCancelAlert = true
                    } label: {
                        Image(systemName: "trash")
                            .foregroundColor(.red)
                    }
                }
            
        }
        .alert("Cancel Order?", isPresented: $showCancelAlert) {
            
            Button("Yes, Cancel", role: .destructive) {
                Task {
                    await viewModel.cancelOrder()
                    selectedTab = viewModel.order.status
                    dismiss()
                }
            }
            
            Button("No", role: .cancel) {}
            
        } message: {
            Text("This order will be canceled")
        }
        .safeAreaInset(edge: .bottom) {
            if viewModel.order.status.hasAction,
               let next = viewModel.order.status.nextStatus {
                
                Button {
                    showConfirmAlert = true
                } label: {
                    Text(viewModel.order.status.actionTitle)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.gauriprimary)
                        .foregroundColor(.white)
                        .cornerRadius(30)
                }
                .padding(.horizontal)
            }
        }
        
        // Rented Alert
        .alert("Product Already Rented", isPresented: $showRentedAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(rentedMessage)
        }
        
        // Confirmation Alert
        .alert("Confirmation", isPresented: $showConfirmAlert) {
            Button("Yes") {
                Task {
                    if let next = viewModel.order.status.nextStatus {
                        
                        if next == .completed {
                            showReturnSheet = true
                            return
                        }
                        
                        // Check selected product availability
                        if next == .toShip {
                            let products = viewModel.items.compactMap { $0.products }

                            let result = productsViewModel.checkConflicts(
                                products: products,
                                startDate: viewModel.order.rentStartDate!,
                                endDate: viewModel.order.rentEndDate!
                            )

                            if result.hasConflict {
                                rentedMessage = result.message
                                showRentedAlert = true
                                return
                            }
                        }
                        
                        
                        
                        await viewModel.updateStatus(to: next)
                        selectedTab = viewModel.order.status
                        dismiss()
                    }
                }
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Are you sure you want to continue?")
        }
        .sheet(isPresented: $showReturnSheet) {

            ReturnInspectionView(
                orders: viewModel.order,
                items: viewModel.items
            ) {
                
                Task {

                    await viewModel.updateStatus(to: .completed)

                    selectedTab = viewModel.order.status

                    dismiss()
                }
            }
        }
        .sheet(isPresented: $showInvoiceSheet) {
            NavigationStack {
                VStack {
                    
                    // Check local PDF
                    if let localURL = InvoiceStorage.get(orderId: viewModel.order.id) {
                        
                        PDFKitView(url: localURL)
                            .onAppear {
                                print("Using LOCAL invoice")
                            }
                        
                    }
                    
                    // Check supabase
                    else if let urlString = viewModel.order.invoiceURL,
                            let remoteURL = URL(string: urlString) {
                        
                        PDFKitView(url: remoteURL)
                            .onAppear {
                                print("Using REMOTE invoice")
                            }
                        
                    }
                    // Invoice unavailable
                    else {
                        Text("Invoice not available")
                            .foregroundColor(.secondary)
                    }
                }
                .navigationTitle("Invoice")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    
                    // Share invoice
                    ToolbarItem(placement: .topBarTrailing) {
                        
                        if let localURL = InvoiceStorage.get(orderId: viewModel.order.id) {
                            
                            ShareLink(item: localURL) {
                                Image(systemName: "square.and.arrow.up")
                            }
                            
                        } else if let urlString = viewModel.order.invoiceURL,
                                  let remoteURL = URL(string: urlString) {
                            
                            ShareLink(item: remoteURL) {
                                Image(systemName: "square.and.arrow.up")
                            }
                        }
                    }
                    
                    // Close
                    ToolbarItem(placement: .topBarLeading) {
                        Button("Done") {
                            showInvoiceSheet = false
                        }
                    }
                }
            }
        }
        .navigationTitle("Order Detail")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.loadOrderItems()
            await viewModel.fetchDressReturn(orderId: viewModel.order.id)
            for item in viewModel.items {
                if let productId = item.products?.id {
                    await productsViewModel.loadBookedRanges(for: productId)
                    await productsViewModel.loadRecoveryRanges(for: productId)
                }
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(AppState())
}
