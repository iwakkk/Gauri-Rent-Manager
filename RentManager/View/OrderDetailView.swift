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
                
                // CUSTOMER INFO
                CustomerInfoSection(order: viewModel.order)
                
                RentDetailSection(
                       order: viewModel.order,
                       rentPeriod: rentPeriod
                   )
                   
                   OrderItemsSection(
                       items: viewModel.items,
                       isLoading: viewModel.isLoading
                   )
                   
                   SummarySection(order: viewModel.order)
                
                // INVOICE
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
            
            // CANCEL BUTTON
            if viewModel.order.status == .unpaid {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showCancelAlert = true
                    } label: {
                        Image(systemName: "trash")
                            .foregroundColor(.red)
                    }
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
        // RENTED ALERT
        .alert("Product Already Rented", isPresented: $showRentedAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("One or more dresses are currently rented.")
        }
        
        // CONFIRM ALERT
        .alert("Confirmation", isPresented: $showConfirmAlert) {
            Button("Yes") {
                Task {
                    if let next = viewModel.order.status.nextStatus {
                        
                        // CHECK ONLY WHEN GOING TO SHIP
                        if next == .toShip {
                            
                            var conflicts: [String] = []
                            
                            let formatter = DateFormatter()
                            formatter.dateFormat = "d MMM"
                            formatter.locale = Locale(identifier: "id_ID")
                            
                            for item in viewModel.items {
                                guard let product = item.products else { continue }
                                
                                let ranges = productsViewModel.bookedRanges[product.id] ?? []
                                
                                let hasConflict = ranges.contains { range in
                                    let (start, end) = range
                                    
                                    return viewModel.order.rentStartDate! <= end &&
                                           viewModel.order.rentEndDate! >= start
                                }
                                
                                if hasConflict {
                                    
                                    let text = ranges.map {
                                        "• \(formatter.string(from: $0.0)) - \(formatter.string(from: $0.1))"
                                    }.joined(separator: "\n")
                                    
                                    conflicts.append("""
                                    \(product.name):
                                    \(text)
                                    """)
                                }
                            }
                            
                            if !conflicts.isEmpty {
                                rentedMessage = """
                                Cannot proceed to ship.

                                \(conflicts.joined(separator: "\n\n"))
                                """
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
        .sheet(isPresented: $showInvoiceSheet) {
            NavigationStack {
                VStack {
                    // CHECK LOCAL
                    if let localURL = InvoiceStorage.get(orderId: viewModel.order.id) {
                        
                        PDFKitView(url: localURL)
                            .onAppear {
                                print("📄 Using LOCAL invoice")
                            }
                        
                    }
                    // CHECK SUPABASE
                    else if let urlString = viewModel.order.invoiceURL,
                            let remoteURL = URL(string: urlString) {
                        
                        PDFKitView(url: remoteURL)
                            .onAppear {
                                print("🌐 Using REMOTE invoice")
                            }
                        
                    }
                    // INVOICE UNAVAILABLE
                    else {
                        Text("Invoice not available")
                            .foregroundColor(.secondary)
                    }
                }
                .navigationTitle("Invoice")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    
                    // SHARE
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
                    
                    //  CLOSE
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
            for item in viewModel.items {
                if let productId = item.products?.id {
                    await productsViewModel.loadBookedRanges(for: productId)
                }
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(AppState())
}
