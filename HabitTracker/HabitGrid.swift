//
//  HabitGrid.swift
//  HabitTracker
//
//  Created by Saikat Kumar Dey on 01/07/23.
//
import SwiftUI

struct HabitGrid: View {
    @ObservedObject var habit: Habit
    let today: Date

    private let columns: [GridItem] = Array(repeating: .init(.fixed(30)), count: 7)
    private let weekDays = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]

    var body: some View {
        VStack {
            LazyVGrid(columns: columns) {
                ForEach(weekDays, id: \.self) { day in
                    Text(day)
                        .font(.caption)
                }
                ForEach(0..<49, id: \.self) { index in
                    cellView(for: index)
                }
            }.padding(10)
        }
    }

    private func cellView(for index: Int) -> some View {
        // cellDate is the date for the grid item
        let cellDate = Calendar.current.date(byAdding: .day, value: index, to: habit.startDate)!
        let isInPast = cellDate < today
        let isInFuture = cellDate > today
        let isToday = Calendar.current.isDate(cellDate, inSameDayAs: today)
        let isCompleted = habit.isCompleted(on: cellDate)

        return ZStack {
            
            RoundedRectangle(cornerRadius: 5)
                .fill(isCompleted ? Color.green : (isToday ? Color.accentColor : isInFuture ? Color.clear : Color.pink))
                .frame(width: 30, height: 30)
            

            ZStack {
                Text("\(cellDate, formatter: dateFormatter)")
                    .font(.system(size: 12, weight: .light, design: .rounded))
                    .foregroundColor(isInPast ? Color.white : Color.black)

                Button(action: {
                    if isInFuture { return }
                    habit.toggleCompletion(for: cellDate)
                }) {
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(Color.black, lineWidth: 1)
                        .frame(width: 30, height: 30)
                    
                }
            }
        }
    }
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        return formatter
    }()
}

struct HabitGrid_Previews: PreviewProvider {
    static var previews: some View {
        // set today to 5 days before
        HabitGrid(habit: Habit(title: "Sample Habit", completedDates: [],startDate: Date().addingTimeInterval(-5*24*3600)), today: Date())
    }
}
