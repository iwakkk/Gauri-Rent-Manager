//
//  OrderDetailView.swift
//  RentManager
//
//  Created by Edward Suwandi on 10/03/26.
//

import SwiftUI

struct OrderDetailView: View {
    
    @State var viewModel: OrderDetailViewModel
    @State private var showInvoiceSheet = false
    @State private var showCancelAlert = false
    @State private var showConfirmAlert = false
    @State private var showRentedAlert = false
    
    @Binding var selectedTab: BookingStatus?
    @Environment(\.dismiss) var dismiss
    
    var rentPeriod: String {
        guard let start = viewModel.booking.rentStartDate, let end = viewModel.booking.rentEndDate else { return "-" }
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy"
        return "\(formatter.string(from: start)) - \(formatter.string(from: end))"
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                
                // Customer Info
                VStack(alignment: .leading, spacing: 8) {
                    Text("Customer Info")
                        .font(.title3.weight(.bold))
                    
                    RowField(title: "Name: ", value: viewModel.booking.customer?.name ?? "-")
                    
                    RowField(title: "Phone: ", value: viewModel.booking.customer?.phone ?? "-")
                    
                    RowField(title: "Address: ", value: viewModel.booking.address ?? "-")
                    
                    RowField(title: "Bank Account: ", value: viewModel.booking.customer?.bankAccount ?? "-")
                    
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(10)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Rent Details")
                        .font(.title3.weight(.bold))
                    
                    // Rent Period & Status
                    HStack {
                        VStack(alignment: .leading) {
                            RowField(title: "Rent Period", value: rentPeriod)
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .trailing) {
                            Text("Status")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            
                            Text(viewModel.booking.status.displayName)
                                .font(.caption.bold())
                                .foregroundColor(viewModel.booking.status.color)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(
                                    viewModel.booking.status.color.opacity(0.15)
                                )
                                .clipShape(Capsule())
                        }
                    }
                    
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(10)
                
                // Items
                VStack(alignment: .leading, spacing: 8) {
                    Text("Ordered Item(s)")
                        .font(.title3.weight(.bold))
                    
                    if viewModel.isLoading {
                        ProgressView()
                    } else if viewModel.items.isEmpty {
                        Text("No items found")
                            .foregroundColor(.secondary)
                    } else {
                        ForEach(viewModel.items) { item in
                            
                            HStack(alignment: .top, spacing: 12) {
                                
                                // PRODUCT IMAGE
                                if let urlString = item.products?.imageUrl,
                                   let url = URL(string: urlString) {
                                    
                                    AsyncImage(url: url) { image in
                                        image
                                            .resizable()
                                            .scaledToFill()
                                    } placeholder: {
                                        Color.gray.opacity(0.2)
                                    }
                                    .frame(width: 70, height: 70)
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                                    
                                } else {
                                    Color.gray.opacity(0.2)
                                        .frame(width: 70, height: 70)
                                        .clipShape(RoundedRectangle(cornerRadius: 12))
                                }
                                
                                // INFO SECTION
                                VStack(alignment: .leading, spacing: 6) {
                                    
                                    Text("\(item.products?.name ?? "-") - \(item.products?.color ?? "-")")
                                        .font(.body.weight(.semibold))
                                    
                                    Text("Qty: \(item.quantity)")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                    
                                    Text("Size: \(item.size)")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                    
                                    Text("Subtotal: Rp \(Int(item.subtotal))")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                
                                Spacer()
                            }
                            .padding(10)
                            .background(Color(.systemBackground))
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                    }
                    
                    
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(10)
                
                // Summary
                VStack(alignment: .leading, spacing: 8) {
                    Text("Summary")
                        .font(.title3.weight(.bold))
                    
                    HStack {
                        Text("Subtotal")
                        Spacer()
                        Text("Rp \(Int(viewModel.booking.subtotalAmount ?? 0))")
                    }
                    HStack {
                        Text("Shipping Fee")
                        Spacer()
                        Text("Rp \(Int(viewModel.booking.shippingFee ?? 0))")
                    }
                    HStack {
                        Text("Deposit")
                        Spacer()
                        Text("Rp \(Int(viewModel.booking.depositAmount ?? 0))")
                    }
                    
                    Divider()
                        .padding(.vertical)
                    HStack {
                        Text("Total")
                            .font(.body.bold())
                        Spacer()
                        Text("Rp \(Int(viewModel.booking.totalAmount ?? 0))")
                            .font(.body.bold())
                    }
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(10)
                
                // Invoice
                if viewModel.booking.invoiceURL != nil {
                    
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
            
            // Tombol cancel (HANYA kalau unpaid)
            if viewModel.booking.status == .unpaid {
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
                    await viewModel.cancelBooking()
                    selectedTab = viewModel.booking.status
                    dismiss()
                }
            }
            
            Button("No", role: .cancel) {}
            
        } message: {
            Text("This order will be canceled")
        }
        .safeAreaInset(edge: .bottom) {
            if viewModel.booking.status.hasAction,
               let next = viewModel.booking.status.nextStatus {
                
                Button {
                    showConfirmAlert = true
                } label: {
                    Text(viewModel.booking.status.actionTitle)
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
                    if let next = viewModel.booking.status.nextStatus {
                        
                        // VALIDASI SEBELUM TO SHIP
                        if next == .toShip {
                            let hasConflict = viewModel.items.contains {
                                $0.products?.isRented == true
                            }
                            
                            if hasConflict {
                                showRentedAlert = true
                                return
                            }
                        }
                        
                        await viewModel.updateStatus(to: next)
                        selectedTab = viewModel.booking.status
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
                    // PRIORITAS LOCAL
                    if let localURL = InvoiceStorage.get(bookingId: viewModel.booking.id) {
                        
                        PDFKitView(url: localURL)
                            .onAppear {
                                print("📄 Using LOCAL invoice")
                            }
                        
                    }
                    
                    // FALLBACK REMOTE
                    else if let urlString = viewModel.booking.invoiceURL,
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
                        
                        if let localURL = InvoiceStorage.get(bookingId: viewModel.booking.id) {
                            
                            ShareLink(item: localURL) {
                                Image(systemName: "square.and.arrow.up")
                            }
                            
                        } else if let urlString = viewModel.booking.invoiceURL,
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
            await viewModel.loadBookingItems()
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(AppState())
}
