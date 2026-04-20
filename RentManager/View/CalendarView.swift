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
            
            Title(title: "Calendar",
                  buttonAction: nil,
                  buttonIcon: ""
            )

            CustomCalendar(
                            selectedDate: $selectedDate,
                            bookings: viewModel.bookings
                        )
            
            Divider()
            
            ScrollView {
                VStack(spacing: 12) {
                    
                    let calendar = Calendar.current

                    let filteredBookings = viewModel.bookings.filter { booking in
                        guard let start = booking.rentStartDate,
                              let end = booking.rentEndDate else { return false }
                        
                        return calendar.compare(selectedDate, to: start, toGranularity: .day) != .orderedAscending &&
                               calendar.compare(selectedDate, to: end, toGranularity: .day) != .orderedDescending
                    }
                    
                    if filteredBookings.isEmpty {
                        Text("No orders on this date")
                            .foregroundColor(.gray)
                            .padding(.top, 20)
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
                .padding()
            }
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
    CalendarView()
}
