//
//  CustomCalendar.swift
//  RentManager
//
//  Created by Edward Suwandi on 01/04/26.
//

import SwiftUI

struct CustomCalendar: View {
    
    @Binding var selectedDate: Date
    var bookings: [Bookings]
    
    @State private var viewModel = CalendarViewModel()
    @State private var currentMonth: Date = Date()
    
    private let daysOfWeek = ["MIN","SEN","SEL","RAB","KAM","JUM","SAB"]
    private let calendar = Calendar.current
    
    var body: some View {
        VStack {
            
            // MONTH NAVIGATION
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
            
            // DAYS OF WEEK
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
            
            // GRID
            LazyVGrid(
                columns: Array(repeating: GridItem(.flexible()), count: 7),
                spacing: 4
            ) {
                ForEach(viewModel.generateDays(for: currentMonth), id: \.self) { date in
                    
                    let normalized = viewModel.normalize(date)
                    
                    let isInMonth = calendar.isDate(date, equalTo: currentMonth, toGranularity: .month)
                    
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
            viewModel.bookings = bookings
        }
        .onChange(of: bookings) { newValue in
            viewModel.bookings = newValue
        }
    }
    
    // MARK: MONTH TITLE
    private func monthTitle() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: currentMonth)
    }
}
