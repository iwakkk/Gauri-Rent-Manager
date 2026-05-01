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
    
    // GENERATE CALENDAR DAYS
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
    
    // NORMALIZE DATE
    func normalize(_ date: Date) -> Date {
        calendar.startOfDay(for: date)
    }
    
    // COUNT ORDERS PER DAY
    func count(for date: Date) -> Int {
        let d = normalize(date)
        
        return orders.filter {
            guard let start = $0.rentStartDate,
                  let end = $0.rentEndDate else { return false }
            
            let s = normalize(start)
            let e = normalize(end)
            
            return d >= s && d <= e
        }.count
    }
    
    // DETECT START DATE
    func isStartDate(_ date: Date) -> Bool {
        let d = normalize(date)
        
        return orders.contains { order in
            guard let start = order.rentStartDate else { return false }
            return normalize(start) == d
        }
    }
    
    // DETECT END DATE
    func isEndDate(_ date: Date) -> Bool {
        let d = normalize(date)
        
        return orders.contains { order in
            guard let end = order.rentEndDate else { return false }
            return normalize(end) == d
        }
    }
    
    // RANGE POSITION
    func rangePosition(for date: Date) -> RangePosition {
        let d = normalize(date)
        
        let hasOrder = orders.contains { order in
            guard let start = order.rentStartDate,
                  let end = order.rentEndDate else { return false }
            
            let s = normalize(start)
            let e = normalize(end)
            
            return d >= s && d <= e
        }
        
        if !hasOrder { return .none }
        
        let prev = calendar.date(byAdding: .day, value: -1, to: d) ?? Date()
        let next = calendar.date(byAdding: .day, value: 1, to: d) ?? Date()
        
        let hasPrev = orders.contains { order in
            guard let start = order.rentStartDate,
                  let end = order.rentEndDate else { return false }
            return prev >= normalize(start) && prev <= normalize(end)
        }
        
        let hasNext = orders.contains { order in
            guard let start = order.rentStartDate,
                  let end = order.rentEndDate else { return false }
            return next >= normalize(start) && next <= normalize(end)
        }
        
        switch (hasPrev, hasNext) {
        case (false, false): return .single
        case (false, true): return .start
        case (true, true): return .middle
        case (true, false): return .end
        }
    }
}
