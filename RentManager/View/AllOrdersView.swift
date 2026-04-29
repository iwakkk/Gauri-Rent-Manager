//
//  AllOrdersView.swift
//  RentManager
//
//  Created by Edward Suwandi on 09/02/26.
//

import SwiftUI

struct AllOrdersView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @State var showOrderSheet = false
    @State var bookings: [Bookings] = []
    @State private var viewModel = AllOrdersViewModel()
    @State private var selectedTab: BookingStatus? = nil
    
    @State private var invoiceCount = 0
    @State private var invoiceSize = 0.0
    
    var filteredBookings: [Bookings] {
        let result: [Bookings]
           
        if let selectedTab {
            result =  viewModel.bookings.filter { $0.status == selectedTab }
        } else {
            result = viewModel.bookings
        }
        return result.sorted {
            $0.rentStartDate ?? .distantFuture < $1.rentStartDate ?? .distantFuture
            }
    }
    
    var body: some View {
        NavigationStack{
            VStack{
                
                // Title
                Title(
                    title: "Orders",
                    actionIcon: "plus.circle.fill",
                    actionTap: {
                        showOrderSheet = true
                    }
                )
              
                // Order List
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        
                        StatusFilter(
                            title: "All",
                            isSelected: selectedTab == nil
                        ) {
                            selectedTab = nil
                        }
                        
                        
                        ForEach(BookingStatus.allCases, id: \.self) { status in
                            StatusFilter(
                                title: status.displayName,
                                isSelected: selectedTab == status
                            ) {
                                selectedTab = status
                            }
                        }
                    }
                    .padding(.horizontal)
                }


                ScrollView {
                    if filteredBookings.isEmpty{
                        BookingEmptyState()
                            .padding(.top, 200)
                            .frame(maxWidth: .infinity)
                    } else {
                        VStack{
                            ForEach(filteredBookings) { booking in
                                
                                NavigationLink(value: booking) {
                                    OrderCard(
                                        booking: booking,
                                        items: viewModel.itemsByBooking[booking.id] ?? []
                                    )
                                }
                            }
                        }
                        .padding(.vertical)
                        
                    }
                    
                }
                .onAppear {
                    invoiceCount = InvoiceStorage.getInvoiceFileCount()
                    invoiceSize = InvoiceStorage.getInvoiceTotalSize()
                       
                       print("📦 Total invoice:", invoiceCount)
                       print("💾 Total size: \(invoiceSize) MB")
                }
                .background(Color.gauribackground.ignoresSafeArea())
                .task {
                    await viewModel.loadOrders()
                }
                .fullScreenCover(isPresented: $showOrderSheet, onDismiss: {
                    Task {
                        await viewModel.loadOrders()
                    }
                }) {
                    NewOrderView(showOrderSheet: $showOrderSheet)
                }
                .navigationDestination(for: Bookings.self) { booking in
                    OrderDetailView(viewModel: OrderDetailViewModel(booking: booking), selectedTab: $selectedTab)
                }
            }
            
        }
        
        
        
    }
    
}

#Preview {
    ContentView()
        .environmentObject(AppState())
}
