//
//  CalendarViewModel.swift
//  RentManager
//
//  Created by Edward Suwandi on 01/04/26.
//

import Foundation
import SwiftUI

enum RangePosition {
    case none
    case start
    case middle
    case end
    case single
}

@Observable
class CalendarViewModel {
    
    var bookings: [Bookings] = []
    var bookingMap: [Date: Int] = [:]
    
    private let calendar = Calendar.current
    
    func generateDays(for month: Date) -> [Date] {
        guard let monthInterval = calendar.dateInterval(of: .month, for: month),
              let firstWeek = calendar.dateInterval(of: .weekOfMonth, for: monthInterval.start),
              let lastWeek = calendar.dateInterval(of: .weekOfMonth, for: monthInterval.end)
        else { return [] }
        
        var days: [Date] = []
        var current = firstWeek.start
        
        while current < lastWeek.end {
            days.append(current)
            current = calendar.date(byAdding: .day, value: 1, to: current) ?? Date()
        }
        
        return days
    }
    
    func buildBookingMap() {
        var map: [Date: Int] = [:]
        
        for booking in bookings {
            guard let start = booking.rentStartDate,
                  let end = booking.rentEndDate else { continue }
            
            var current = normalize(start)
            let endDate = normalize(end)
            
            while current <= endDate {
                map[current, default: 0] += 1
                current = calendar.date(byAdding: .day, value: 1, to: current) ?? Date()
            }
        }
        
        bookingMap = map
    }
    
    func normalize(_ date: Date) -> Date {
        calendar.startOfDay(for: date)
    }
    
    func count(for date: Date) -> Int {
        bookingMap[normalize(date)] ?? 0
    }
    
    func rangePosition(for date: Date) -> RangePosition {
        let d = normalize(date)
        
        let hasCurrent = bookingMap[d] ?? 0 > 0
        if !hasCurrent { return .none }
        
        let prev = calendar.date(byAdding: .day, value: -1, to: d) ?? Date()
        let next = calendar.date(byAdding: .day, value: 1, to: d) ?? Date()
        
        let hasPrev = (bookingMap[prev] ?? 0) > 0
        let hasNext = (bookingMap[next] ?? 0) > 0
        
        switch (hasPrev, hasNext) {
        case (false, false):
            return .single
        case (false, true):
            return .start
        case (true, true):
            return .middle
        case (true, false):
            return .end
        }
    }
}
