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
                
                let visibleOrders = viewModel.orders.filter {
                    $0.status != .unpaid && $0.status != .cancelled
                }
                
                CustomCalendar(
                    selectedDate: $selectedDate,
                    orders: visibleOrders
                )
                .padding()
                
                Divider()
                
                HStack(spacing: 16) {
                    
                    HStack(spacing: 6) {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.green)
                            .frame(width: 14, height: 14)
                        
                        Text("Start Date")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    
                    HStack(spacing: 6) {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.blue.opacity(0.4))
                            .frame(width: 14, height: 14)
                        
                        Text("Ongoing Days")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
                .padding(.horizontal)
                .padding(.top, 8)
                
                ScrollView {
                    VStack(spacing: 12) {
                        
                        let calendar = Calendar.current
                        
                        let filteredOrders = visibleOrders.filter { booking in
                            
                            guard let start = booking.rentStartDate,
                                  let end = booking.rentEndDate else { return false }
                            
                            return Calendar.current.compare(selectedDate, to: start, toGranularity: .day) != .orderedAscending &&
                            Calendar.current.compare(selectedDate, to: end, toGranularity: .day) != .orderedDescending
                        }
                        
                        if filteredOrders.isEmpty {
                            OrderEmptyState()
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .padding(.top, 100)
                        } else {
                            ForEach(filteredOrders) { booking in
                                
                                NavigationLink(value: booking) {
                                    OrderCard(
                                        order: booking,
                                        items: viewModel.itemsByOrder[booking.id] ?? []
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

