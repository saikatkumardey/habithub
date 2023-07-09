//
//  HabitCalendarView.swift
//  HabitTracker
//
//  Created by Saikat Kumar Dey on 09/07/23.
//
import Foundation
import SwiftUI

struct HabitCalendarView: View {
//    @State var selectedDate: Date = Date()
    @State private var dates: Set<DateComponents> = [DateComponents(calendar: .current, year: 2023, month: 7, day: 11)]
    
    var fromDate: Date {
        let calendar = Calendar.current
        let components = DateComponents(calendar: calendar, year: 2023, month: 7, day: 1)
        return calendar.date(from: components)!
    }
    
    var toDate: Date {
        let calendar = Calendar.current
        let components = DateComponents(calendar: calendar, year: 2023, month: 7, day: 10)
        return calendar.date(from: components)!
    }

    public var body: some View {
        VStack() {
        MultiDatePicker("",selection: $dates, in: fromDate..<toDate)
                .padding(.horizontal,50)
                .frame(width: 500)
                .tint(.green)
                .padding()
        }
        .padding(100)
    }
}

struct HabitCalendarView_Previews: PreviewProvider {
    static var previews: some View {
        HabitCalendarView()
    }
}

