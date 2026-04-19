//
//  AllOrdersView.swift
//  RentManager
//
//  Created by Edward Suwandi on 09/02/26.
//

import SwiftUI

struct AllOrdersView: View {
    
    @State var showOrderSheet = false
    @Environment(\.dismiss) var dismiss
    @State var bookings: [Bookings] = []
    
    @State private var viewModel = AllOrdersViewModel()
    
    @State private var selectedTab: BookingStatus? = nil
    
    var filteredBookings: [Bookings] {
        if let selectedTab {
            return viewModel.bookings.filter { $0.status == selectedTab }
        } else {
            return viewModel.bookings
        }
    }
    
    var body: some View {
        NavigationStack{
            VStack{
                
                // Title
                Title(title: "Orders",
                      buttonAction: { showOrderSheet = true},
                      buttonIcon: "plus.circle.fill"
                )
                
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
                    
                }
                .task {
                    await viewModel.loadOrders()
                }
                .fullScreenCover(isPresented: $showOrderSheet) {
                    NewBookingView(showOrderSheet: $showOrderSheet)
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
