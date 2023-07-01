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
            }
        }
    }

    private func cellView(for index: Int) -> some View {
        let cellDate = Calendar.current.date(byAdding: .day, value: index - 24, to: today)!
        let isInPast = cellDate < today
        let isInFuture = cellDate > today
        let isCompleted = habit.isCompleted(on: cellDate)
        let isToday = Calendar.current.isDate(cellDate, inSameDayAs: today)

        return ZStack {
            RoundedRectangle(cornerRadius: 5)
                .fill(isCompleted ? Color.green : (isInPast ? Color.red : Color.white))
                .frame(width: 30, height: 30)

            ZStack {
                Text("\(cellDate, formatter: dateFormatter)")
                    .font(.caption2)
                    .foregroundColor(isInPast ? Color.white : Color.black)

                Button(action: {
                    if isInFuture { return }
                    habit.toggleCompletion(for: cellDate)
                }) {
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(isToday ? Color.gray : Color.black, lineWidth: 1)
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
        HabitGrid(habit: Habit(title: "Sample Habit", count: 0, completedDates: []), today: Date())
    }
}
