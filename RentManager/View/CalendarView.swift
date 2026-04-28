//
//  CalendarView.swift
//  RentManager
//
//  Created by Edward Suwandi on 09/02/26.
//

import SwiftUI

struct CalendarView: View {
    @State private var selectedDate = Date()
    @State private var viewModel = AllOrdersViewModel()
    
    @State private var hasScrolled = false
    @State private var isCollapsed = false
    
    var body: some View {
        
        VStack {
            Title(
                title: "Calendar",
                actionIcon: nil,
                actionTap: nil
            )
            
            VStack {
                
                let visibleBookings = viewModel.bookings.filter {
                    $0.status != .unpaid && $0.status != .cancelled
                }
                
                CustomCalendar(
                    selectedDate: $selectedDate,
                    bookings: visibleBookings
                )
                .padding()
                Divider()
                
                ScrollView {
                    VStack(spacing: 12) {
                        
                        let calendar = Calendar.current
                        
                        let filteredBookings = visibleBookings.filter { booking in
                            
                            guard let start = booking.rentStartDate,
                                  let end = booking.rentEndDate else { return false }
                            
                            return Calendar.current.compare(selectedDate, to: start, toGranularity: .day) != .orderedAscending &&
                            Calendar.current.compare(selectedDate, to: end, toGranularity: .day) != .orderedDescending
                        }
                        
                        if filteredBookings.isEmpty {
                            BookingEmptyState()
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .padding(.top, 100)
                        } else {
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
                    .padding(.vertical)
                }
            }
            .background(Color.gauribackground.ignoresSafeArea())
        }
        
        .task {
            await viewModel.loadOrders()
        }
        
    }
    func isSameDay(_ date1: Date, _ date2: Date) -> Bool {
        Calendar.current.isDate(date1, inSameDayAs: date2)
    }
}

#Preview {
    ContentView()
        .environmentObject(AppState())
}

