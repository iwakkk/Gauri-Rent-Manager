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
    @State var orders: [Orders] = []
    @State private var viewModel = AllOrdersViewModel()
    @State private var selectedTab: OrderStatus? = nil
    @State private var invoiceCount = 0
    @State private var invoiceSize = 0.0
    
    var filteredOrders: [Orders] {
        let result: [Orders]
           
        if let selectedTab {
            result =  viewModel.orders.filter { $0.status == selectedTab }
        } else {
            result = viewModel.orders
        }
        return result.sorted {
            let aIsInactive = $0.status == .completed || $0.status == .cancelled
            let bIsInactive = $1.status == .completed || $1.status == .cancelled
            
            if aIsInactive != bIsInactive {
                return !aIsInactive
            }
            
            return ($0.rentStartDate ?? .distantFuture) < ($1.rentStartDate ?? .distantFuture)
        }
    }
    
    var body: some View {
        NavigationStack{
            VStack{
                
                // TITLE
                Title(
                    title: "Orders",
                    actionIcon: "plus.circle.fill",
                    actionTap: {
                        showOrderSheet = true
                    }
                )
              
                // ORDER LIST
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
                .onAppear {
                    invoiceCount = InvoiceStorage.getInvoiceFileCount()
                    invoiceSize = InvoiceStorage.getInvoiceTotalSize()
                       
                       print("Total invoice:", invoiceCount)
                       print("Total size: \(invoiceSize) MB")
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
                .navigationDestination(for: Orders.self) { order in
                    OrderDetailView(viewModel: OrderDetailViewModel(order: order), selectedTab: $selectedTab)
                }
            }
            
        }
        
        
        
    }
    
}

#Preview {
    ContentView()
        .environmentObject(AppState())
}
