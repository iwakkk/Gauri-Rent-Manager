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
                
                // MARK: Customer Info
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
                    
                    // MARK: Rent Period & Status
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
                
                // MARK: Items
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
                            VStack{
                                HStack {
                                    Text(item.products?.name ?? "-")
                                    Spacer()
                                    Text("x\(item.quantity)")
                                    Spacer()
                                    Text("Rp \(Int(item.subtotal))")
                                }
                                .padding(.vertical, 4)
                            }
                            
                        }
                    }
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(10)
                
                // MARK: Summary
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
                
                // MARK: Invoice
                if let urlString = viewModel.booking.invoiceURL,
                   let url = URL(string: urlString) {
                    
                    Button {
                        showInvoiceSheet = true
                    } label: {
                        HStack {
                            Image(systemName: "doc.text")
                            Text("Lihat Invoice")
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue.opacity(0.1))
                        .foregroundColor(.blue)
                        .cornerRadius(10)
                    }
                    
                } else {
                    Text("Invoice belum tersedia")
                        .foregroundColor(.secondary)
                }
                
                Spacer()
            }
            .padding()
            
        }
        .background(Color(.systemGroupedBackground))
//        .toolbar {
//            
//            // tombol cancel (HANYA kalau unpaid)
//            if viewModel.booking.status == .unpaid {
//                ToolbarItem(placement: .topBarTrailing) {
//                    Button {
//                        showCancelAlert = true
//                    } label: {
//                        Image(systemName: "trash")
//                            .foregroundColor(.red)
//                    }
//                }
//            }
//        }
//        .safeAreaInset(edge: .bottom){
//            
//            if viewModel.booking.status.hasAction,
//               let next = viewModel.booking.status.nextStatus {
//                
//                Button {
//                    showConfirmAlert = true
//                } label: {
//                    Text(booking.status.actionTitle)
//                        .frame(maxWidth: .infinity)
//                        .padding()
//                        .background(Color.blue)
//                        .foregroundColor(.white)
//                        .cornerRadius(30)
//                }
//                .padding(.horizontal)
//            }
//            
//        }
//        .alert("Batalkan Pesanan?", isPresented: $showCancelAlert) {
//            
//            Button("Ya, Batalkan", role: .destructive) {
//                Task {
//                    isUpdating = true
//                    do {
//                        try await BookingsService().updateStatus(
//                            bookingId: booking.id,
//                            status: .cancelled
//                        )
//                        
//                        toastMessage = "Pesanan berhasil dibatalkan"
//                        showToast = true
//                        selectedTab = booking.status.nextStatus
//                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
//                            dismiss()
//                        }
//                        
//                    } catch {
//                        print("❌ Failed cancel:", error)
//                    }
//                    isUpdating = false
//                }
//            }
//            
//            Button("Tidak", role: .cancel) { }
//            
//        } message: {
//            Text("Pesanan ini akan dibatalkan dan tidak bisa dikembalikan.")
//        }
//        .alert("Konfirmasi", isPresented: $showConfirmAlert) {
//            
//            Button("Ya") {
//                Task {
//                    isUpdating = true
//                    do {
//                        if let next = booking.status.nextStatus {
//                            try await BookingsService().updateStatus(
//                                bookingId: booking.id,
//                                status: next
//                            )
//                            
//                            toastMessage = "Status berhasil diupdate"
//                            showToast = true
//                            selectedTab = booking.status.nextStatus
//                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
//                                dismiss()
//                            }
//                        }
//                    } catch {
//                        print("❌ Failed update:", error)
//                    }
//                    isUpdating = false
//                }
//            }
//            
//            Button("Batal", role: .cancel) { }
//            
//        } message: {
//            Text("Apakah Anda yakin ingin melanjutkan?")
//        }
//        .overlay(alignment: .top) {
//            if showToast {
//                Text(toastMessage)
//                    .padding(.horizontal, 16)
//                    .padding(.vertical, 10)
//                    .background(Color.green.opacity(0.8))
//                    .foregroundColor(.white)
//                    .cornerRadius(12)
//                    .padding(.top, 60)
//                    .transition(.move(edge: .top).combined(with: .opacity))
//                    .onAppear {
//                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
//                            withAnimation {
//                                showToast = false
//                            }
//                        }
//                    }
//            }
//        }
//        .animation(.easeInOut, value: showToast)
        .sheet(isPresented: $showInvoiceSheet) {
            NavigationStack{
                if let urlString = viewModel.booking.invoiceURL,
                   let url = URL(string: urlString) {
                    PDFKitView(url: url)
                        .navigationTitle("Invoice")
                        .navigationBarTitleDisplayMode(.inline)
                        .toolbar {
                            ToolbarItem(placement: .topBarTrailing) {
                                ShareLink(item: url) {
                                    Image(systemName: "square.and.arrow.up")
                                }
                            }
                            ToolbarItem(placement: .topBarLeading) {
                                Button("Done") {
                                    showInvoiceSheet = false
                                }
                            }
                        }
                }
            }
        }
        .navigationTitle("Booking Detail")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.loadBookingItems()
        }
    }
    
//    // MARK: Fetch Booking Items with Products
//    func loadBookingItems() async {
//        isLoading = true
//        do {
//            let fetchedItems = try await BookingsService().fetchItems(for: booking.id)
//            self.items = fetchedItems
//        } catch {
//            print("❌ Failed to fetch booking items:", error)
//            self.items = []
//        }
//        isLoading = false
//    }
    
  
}

#Preview {
    ContentView()
        .environmentObject(AppState())
}
