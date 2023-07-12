//
//  HabitRowView.swift
//  HabitTracker
//
//  Created by Saikat Kumar Dey on 09/07/23.
//

import SwiftUI

struct HabitRow: View {
    @EnvironmentObject var habitStore: HabitStore
    @ObservedObject var habit: Habit
    @State private var isAddHabitSheetPresented = false
    
    var body: some View {
        HStack (alignment: .top) {
            VStack(alignment: .leading,spacing: 5) {
                Text(habit.title)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                if !habit.isHabitCompleted{
                    Text("Current streak: \(habit.calculateStreak()) days")
                        .font(.caption)
                        .foregroundColor(.primary)
                    Text("Longest streak: \(habit.calculateLongestStreak()) days")
                        .font(.caption)
                        .foregroundColor(.primary)
                    // last 7 days
                    let lastNdays = habit.lastNdayCells(n: 7)
                    
                    
                    HStack {
                        ForEach(0..<lastNdays.count, id: \.self) { index in
                            let cell = lastNdays[index]
                            if cell == 1 {
//                                Image(systemName: "checkmark.circle.fill")
//                                    .foregroundColor(.green)
                                Circle()
                                    .fill(Color.green)
                                    .frame(width: 20, height: 20)
                            } else {
                                Circle()
                                    .fill(Color.gray.opacity(0.5))
                                    .frame(width: 20, height: 20)
//                                Image(systemName: "xmark.circle.fill")
//                                    .foregroundColor(.gray.opacity(0.5))
                            }
                        }
                    }
                } else {
                    // completed on date
                    if habit.completedDate != nil {
                        Text("Completed on \(habit.completedDate!.formatted(date: .abbreviated, time: .omitted))")
                            .font(.subheadline)
                            .foregroundColor(.primary)
                    }
                }
            }.padding(.top,10)
                .environment(\.font, Font.system(size: 16, weight: .light, design: .serif))
            
            Spacer()
            Spacer()
            
            if !habit.isHabitCompleted{
                Button(action: {
                    isAddHabitSheetPresented.toggle()
                }) {
                    Image(systemName: "info.circle")
                        .foregroundColor(.blue)
                        .font(.subheadline)
                }
                .sheet(isPresented: $isAddHabitSheetPresented) {
                    EditHabit(habit: habit)
                        .environmentObject(habitStore)
                }
            }
        }
    }
        
}


#Preview {
    HabitRow(habit: Habit(title: "Drink water", completedDates: [], startDate: Date(), reminderTime: Date(), isReminderEnabled: false))
        .padding()
}