//
//  CustomCalendar.swift
//  RentManager
//
//  Created by Edward Suwandi on 01/04/26.
//

import SwiftUI

struct CustomCalendar: View {
    
    @Binding var selectedDate: Date
    
    @State private var viewModel = CalendarViewModel()
    @State private var currentMonth: Date = Date()
    
    var orders: [Orders]
    private let daysOfWeek = ["MIN","SEN","SEL","RAB","KAM","JUM","SAB"]
    private let calendar = Calendar.current
    
    var body: some View {
        VStack {
            
            // Month Navigation
            HStack {
                Button {
                    currentMonth = calendar.date(byAdding: .month, value: -1, to: currentMonth) ?? Date()
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.headline)
                }
                
                Spacer()
                
                Text(monthTitle())
                    .font(.title2)
                    .fontWeight(.bold)
                
                Spacer()
                
                Button {
                    currentMonth = calendar.date(byAdding: .month, value: 1, to: currentMonth) ?? Date()
                } label: {
                    Image(systemName: "chevron.right")
                        .font(.headline)
                }
            }
            .padding(.horizontal)
            
            // Days of Week
            HStack {
                ForEach(daysOfWeek, id: \.self) { day in
                    Text(day)
                        .font(.caption2)
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.gray)
                }
            }
            .padding(.horizontal)
            .padding(.top, 4)
            
            // Date Grid with 7 Columns
            LazyVGrid(
                columns: Array(repeating: GridItem(.flexible()), count: 7),
                spacing: 4
            ) {
                // Generate calendar dates from view model
                ForEach(viewModel.generateDays(for: currentMonth), id: \.self) { date in
                    
                    // Check whether the date belongs to the currently displayed month, used to style dates from prev/next month differently
                    let isInMonth = calendar.isDate(date, equalTo: currentMonth, toGranularity: .month)
                    
                    // Display a single calendar date cell
                    DateCell(
                        date: date,
                        selectedDate: selectedDate,
                        inCurrentMonth: isInMonth,
                        count: viewModel.count(for: date),
                        position: viewModel.rangePosition(for: date),
                        isStartDate: viewModel.isStartDate(date),
                        isEndDate: viewModel.isEndDate(date),
                        onTap: {
                            selectedDate = date
                        }
                    )
                }
            }
            .padding(.horizontal)
        }
        .onAppear {
            viewModel.orders = orders
        }
        .onChange(of: orders) { newValue in
            viewModel.orders = newValue
        }
    }
    
    // Month Title
    private func monthTitle() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: currentMonth)
    }
}
