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
    
    var body: some View {
        ScrollView{
            VStack(alignment: .leading, spacing: 20){
//                TextField("Habit title", text: $habit.title)
//                    .font(.system(size: 24, weight: .light, design: .serif))
//                    .padding(.bottom)
                TextField("Habit title", text: $habit.title, axis: .vertical)
                    .font(.system(size: 24, weight: .light, design: .rounded))
                    .lineLimit(2)
                Text("started on \(habit.startDate.formatted(date: .abbreviated, time: .omitted))")
                    .font(.system(size: 12, weight: .light, design: .rounded))
                    .foregroundColor(.secondary)
                Divider()
                                
                MultiDatePicker("Calendar",selection: $habit.completedDates, in: habit.startDate..<today)
//                    .frame(width: 300)
                    .fontDesign(.rounded)
                    .tint(.green)
                    .onChange(of: habit.completedDates, perform: { value in
                        habitStore.updateHabit(habit)
                    })
                    .padding(.vertical,20)
                    .padding(.horizontal,20)
                
                Divider()
                
                let totalCompleted = habit.calculateTotalCompleted()
                let currentStreak = habit.calculateStreak()
                let longestStreak = habit.calculateLongestStreak()
                

                VStack(alignment: .center, spacing: 10){
                    HStack(alignment:.top){
                        Text("Total completed")
                            .font(.system(size: 16, weight: .light, design: .monospaced))
                        Spacer()
                        Text("\(totalCompleted) \(totalCompleted == 1 ? "day" : "days")")
                            .fontDesign(.monospaced)
                    }
                    
                    HStack(alignment: .top) {
                        Text("Current Streak")
                            .font(.system(size: 16, weight: .light, design: .monospaced))
                        Spacer()
                        Text("\(currentStreak) \(currentStreak == 1 ? "day" : "days")")
                            .fontDesign(.monospaced)
                    }
                    HStack(alignment: .top) {
                        Text("Longest Streak")
                            .font(.system(size: 16, weight: .light, design: .monospaced))
                        Spacer()
                        Text("\(longestStreak) \(longestStreak == 1 ? "day" : "days")")
                            .fontDesign(.monospaced)
                    
                    }
                }.padding(.top,50)                
            }
            .padding([.leading,.trailing],20)
            .padding(.vertical,10)
            .navigationBarItems(trailing: Button("Done") {
                dismiss()
            }
                .font(.system(size: 30, weight: .light, design: .rounded))
            )
        }
    }
}

struct HabitDetailView_Previews: PreviewProvider {
    static var previews: some View {
        HabitDetailView(habit: Habit(title: "Sample Habit", completedDates: [], startDate: Date().addingTimeInterval(-86400*7),reminderTime: Date()))
    }
}
