//
//  CalendarViewModel.swift
//  RentManager
//
//  Created by Edward Suwandi on 01/04/26.
//

import Foundation

enum RangePosition {
    case none
    case start
    case middle
    case end
    case single
}

@Observable
class CalendarViewModel {
    
    var orders: [Orders] = []
    
    private let calendar = Calendar.current
    
    // Generate Calendar Days
    func generateDays(for month: Date) -> [Date] {
        
        // Get the whole 1 month date
        guard let monthInterval = calendar.dateInterval(of: .month, for: month),
              
              // Get the week that contains the first day of the month, if the month starts on friday, calendar show remaining days from prev month
              let firstWeek = calendar.dateInterval(of: .weekOfMonth, for: monthInterval.start),
              
              // Get the week that contains the last day of the month, if the month ends on friday, calendar show remaining days from next month
              let lastWeek = calendar.dateInterval(of: .weekOfMonth, for: monthInterval.end)
        else { return [] }
        
        // Array to store all calendar dates
        var days: [Date] = []
        
        // Start from the first visible day in the calendar
        var current = firstWeek.start
        
        // Loop through each day until the end of the last visible week
        while current < lastWeek.end {
            
            // Add current date into the calendar array
            days.append(current)
            
            // Move to next day
            current = calendar.date(byAdding: .day, value: 1, to: current) ?? Date()
        }
        
        // Return days that contains complete days of calendar
        return days
    }
    
    // Func to normalize date (to remove hour, minute, and second)
    func normalize(_ date: Date) -> Date {
        calendar.startOfDay(for: date)
    }
    
    // Count orders per date
    func count(for date: Date) -> Int {
        
        // Normalize selected date
        let d = normalize(date)
        
        // Filter orders that are active on selected date
        return orders.filter {
            
            // Get the rental start and end date
            guard let start = $0.rentStartDate,
                  let end = $0.rentEndDate else { return false }
            
            // Normalize the date
            let s = normalize(start)
            let e = normalize(end)
            
            // Check whether the selected date is within the rental period
            return d >= s && d <= e
        }
        // Return the total number of matching orders
        .count
    }
    
    // Detect Rent Start Date
    func isStartDate(_ date: Date) -> Bool {
        let d = normalize(date)
        
        return orders.contains { order in
            guard let start = order.rentStartDate else { return false }
            return normalize(start) == d
        }
    }
    
    // Detect Rent End Date
    func isEndDate(_ date: Date) -> Bool {
        let d = normalize(date)
        
        return orders.contains { order in
            guard let end = order.rentEndDate else { return false }
            return normalize(end) == d
        }
    }
    
    // Define Order Date Range
    func rangePosition(for date: Date) -> RangePosition {
        
        // Normalize date
        let d = normalize(date)
        
        // Check whether selected date is within any rental period
        let hasOrder = orders.contains { order in
            guard let start = order.rentStartDate,
                  let end = order.rentEndDate else { return false }
            
            let s = normalize(start)
            let e = normalize(end)
            
            return d >= s && d <= e
        }
        
        // Return none if current date has no order
        if !hasOrder { return .none }
        
        // Get prev and next day
        let prev = calendar.date(byAdding: .day, value: -1, to: d) ?? Date()
        let next = calendar.date(byAdding: .day, value: 1, to: d) ?? Date()
        
        // Check whether previous day is part of any rental range
        let hasPrev = orders.contains { order in
            guard let start = order.rentStartDate,
                  let end = order.rentEndDate else { return false }
            return prev >= normalize(start) && prev <= normalize(end)
        }
        
        // Check whether next day is part of any rental rage
        let hasNext = orders.contains { order in
            guard let start = order.rentStartDate,
                  let end = order.rentEndDate else { return false }
            return next >= normalize(start) && next <= normalize(end)
        }
        
        switch (hasPrev, hasNext) {
            
        // Date is not connected to any other rental day
        case (false, false): return .single
            
        // Date is the beginning of the rental range
        case (false, true): return .start
            
        // Date is in between of the rental range
        case (true, true): return .middle
            
        // Date is the last day of the rental range
        case (true, false): return .end
            
        }
    }
}
