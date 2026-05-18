//
//  AllOrdersView.swift
//  RentManager
//
//  Created by Edward Suwandi on 09/02/26.
//

import SwiftUI

struct AllOrdersView: View {
    
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) var dismiss
    
    @State var showOrderSheet = false
    @State var orders: [Orders] = []
    @State private var viewModel = AllOrdersViewModel()
    @State private var selectedTab: OrderStatus? = nil
    @State private var invoiceCount = 0
    @State private var invoiceSize = 0.0
    
    var filteredOrders: [Orders] {
        let result: [Orders]
         
        // Check current selected tab
        if let selectedTab {
            
            // Shows all orders with status matching the currently selected tab
            result =  viewModel.orders.filter { $0.status == selectedTab }
        } else {
            
            // Show all orders a nil selected tab means the user is currently on the "all orders" tab
            result = viewModel.orders
        }
        
        // Sort the result
        return result.sorted {
            
            //Check if the first order is completed or cancelled
            let aIsInactive = $0.status == .completed || $0.status == .cancelled
            
            // Check if the second order is completed or cancelled
            let bIsInactive = $1.status == .completed || $1.status == .cancelled
            
            // Check if one order is inactive while the other is active
            if aIsInactive != bIsInactive {
                
                // Place the active order before the inactive order
                return !aIsInactive
            }
            
            // Sort by closest rent start date first
            return ($0.rentStartDate ?? .distantFuture) < ($1.rentStartDate ?? .distantFuture)
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
              
                // Order Status Tab
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        
                        StatusFilter(
                            title: "All",
                            isSelected: selectedTab == nil
                        ) {
                            selectedTab = nil
                        }
                        
                        ForEach(OrderStatus.allCases, id: \.self) { status in
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

                // Orders List
                ScrollView {
                    if filteredOrders.isEmpty{
                        OrderEmptyState()
                            .padding(.top, 200)
                            .frame(maxWidth: .infinity)
                    } else {
                        VStack{
                            ForEach(filteredOrders) { booking in
                                
                                NavigationLink(value: booking) {
                                    OrderCard(
                                        order: booking,
                                        items: viewModel.itemsByOrder[booking.id] ?? []
                                    )
                                }
                            }
                        }
                        .padding(.vertical)
                    }
                }
                // Check invoice local size and count.
                .onAppear {
                    invoiceCount = InvoiceStorage.getInvoiceFileCount()
                    invoiceSize = InvoiceStorage.getInvoiceTotalSize()
                       
                       print("Total invoice:", invoiceCount)
                       print("Total size: \(invoiceSize) MB")
                }
                .background(Color.gauribackground.ignoresSafeArea())

                // Load orders
                .task {
                    await viewModel.loadOrders()
                }
                
                // Load orders when done creating new order
                .fullScreenCover(isPresented: $showOrderSheet, onDismiss: {
                    Task {
                        await viewModel.loadOrders()
                    }
                }) {
                    NewOrderView(showOrderSheet: $showOrderSheet)
                }
                
                // Navigate to order detail view
                .navigationDestination(for: Orders.self) { order in
                    OrderDetailView(viewModel: OrderDetailViewModel(order: order), selectedTab: $selectedTab)
                }
                
                // Navigate to new order view when receiving new text from share extension
                .onChange(of: appState.shouldOpenNewOrder) { _, newValue in
                    if newValue {
                        showOrderSheet = true
                        appState.shouldOpenNewOrder = false
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(AppState())
}
