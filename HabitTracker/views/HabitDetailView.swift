//
//  HabitDetailView.swift
//  HabitTracker
//
//  Created by Saikat Kumar Dey on 01/07/23.
//

import SwiftUI

struct HabitDetailView: View {
    @EnvironmentObject var habitStore: HabitStore
    @Environment(\.dismiss) var dismiss
    @ObservedObject var habit: Habit
    let today: Date = Date()
    @State private var showDatePicker = false
    @State private var selectedDate = Date()
    @FocusState private var isFocused: Bool
    
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }
    
    var body: some View {
        ScrollView{
            VStack(alignment: .leading){
                
                TextField("Habit title", text: $habit.title, axis: .vertical)
                    .font(.system(size: 24, weight: .light, design: .rounded))
                    .focused($isFocused)
                    .lineLimit(2)
                    .padding(.horizontal,10)
                    .padding(.bottom,10)
                
                DateSelectionView(title: "Started on",selectedDate: $habit.startDate)
                    .font(.system(size: 12, weight: .light, design: .rounded))
                    .onChange(of: habit.startDate, perform: { value in
                        habitStore.updateHabit(habit)
                    })
                    .padding(.horizontal,20)
                
                ReminderConfigurationView(reminderTime: $habit.reminderTime, isReminderEnabled: $habit.isReminderEnabled)
                    .font(.system(size: 12, weight: .light, design: .rounded))
                    .onChange(of: habit.reminderTime, perform: { value in
                        habitStore.updateHabit(habit)
                    })
                    .padding(.horizontal,20)


                
                Divider()
                
                if habit.startDate <= today {
                    MultiDatePicker("Calendar",selection: $habit.completedDates, in: habit.startDate..<today)
                        .fontDesign(.rounded)
                        .tint(.green)
                        .onChange(of: habit.completedDates, perform: { value in
                            habitStore.updateHabit(habit)
                        })
                        .padding(.all,10)
                }
                
                let totalCompleted = habit.calculateTotalCompleted()
                let currentStreak = habit.calculateStreak()
                let longestStreak = habit.calculateLongestStreak()
                
                VStack(alignment:.leading, spacing: 10){
                    HStack(alignment: .center){
                        NumberCard(number: totalCompleted, text: "✅ Total", fillColor: .pink)
                        NumberCard(number: currentStreak, text: "🔥 Current Streak", fillColor: .green)
                    }
                    NumberCard(number: longestStreak, text: "🏆 Longest Streak", fillColor: .blue)
                }
                .padding(.horizontal,10)
                .padding(.vertical,10)
            }
            .navigationBarItems(
                trailing: Button("Done") {
                    dismiss()
                }
            )
        }
        .padding(10)
    }
}

struct HabitDetailView_Previews: PreviewProvider {
    static var previews: some View {
        HabitDetailView(habit: Habit(title: "Sample Habit", completedDates: [], startDate: Date().addingTimeInterval(-86400*15),reminderTime: Date()))
            .environmentObject(HabitStore())
    }
}
