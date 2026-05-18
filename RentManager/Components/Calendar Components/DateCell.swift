//
//  DateCell.swift
//  RentManager
//
//  Created by Edward Suwandi on 01/04/26.
//

import SwiftUI

struct DateCell: View {
    
    let date: Date
    let selectedDate: Date
    let inCurrentMonth: Bool
    let count: Int
    let position: RangePosition
    let isStartDate: Bool
    let isEndDate: Bool
    let onTap: () -> Void
    
    private let calendar = Calendar.current
    
    var body: some View {
        Button(action: onTap) {
            
            VStack(spacing: 2) {
                
                ZStack {
                    
                    // Date Cel Background
                    RoundedRectangle(cornerRadius: 8)
                        .fill(backgroundColor)
                    
                    VStack(spacing: 2) {
                        
                        // Date
                        Text("\(calendar.component(.day, from: date))")
                            .font(.subheadline)
                            .fontWeight(isSelected ? .semibold : .regular)
                            .foregroundColor(textColor.opacity(opacitySetting))
                        
                        // Order Count Indicator
                        if count > 0 {
                            HStack(spacing: 3) {
                                Circle()
                                    .fill(Color.red)
                                    .frame(width: 4, height: 4)
                                
                                Text(count > 9 ? "9+" : "\(count)")
                                    .font(.caption2.bold())
                                    .foregroundColor(textColor.opacity(opacitySetting))
                            }
                        } else {
                            Spacer().frame(height: 10)
                        }
                    }
                }
                .frame(width: 38, height: 44)
            }
        }
        .buttonStyle(.plain)
    }
    
    // Background Color for Date Cell
    private var backgroundColor: Color {
        if isSelected {
            return .blue
            
        } else if isStartDate {
            return .green.opacity(0.85)
            
        } else if isEndDate {
            return .blue.opacity(0.10)
            
        } else if isToday {
            return .blue.opacity(0.4)
            
        } else if position == .middle {
            return .blue.opacity(0.10)
            
        } else {
            return .clear
        }
    }
    
    // States
    private var isSelected: Bool {
        calendar.isDate(date, inSameDayAs: selectedDate)
    }
    
    private var isToday: Bool {
        calendar.isDateInToday(date)
    }
    
    private var opacitySetting: Double {
        inCurrentMonth ? 1 : 0.3
    }
    
    private var textColor: Color {
        isSelected ? .white : .primary
    }
}
#Preview {
    ContentView()
}
