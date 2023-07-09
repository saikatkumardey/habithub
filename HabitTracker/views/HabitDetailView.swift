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
            VStack{
                TextField("Habit title", text: $habit.title)
                    .font(.system(size: 24, weight: .light, design: .serif))
                    .padding(.bottom)
                
                Divider()
                
                MultiDatePicker("Calendar",selection: $habit.completedDates, in: habit.startDate..<today)
                    .frame(width: 300)
                    .tint(.green)
                    .onChange(of: habit.completedDates, perform: { value in
                        habitStore.updateHabit(habit)
                    })
                
                Divider()
                
                // toggle for completing habit
                
                Toggle("Completed", isOn: $habit.isHabitCompleted)
                    .toggleStyle(SwitchToggleStyle(tint: .green))
                    .padding()
                    .onChange(of: habit.isHabitCompleted) { value in
                        if habit.isHabitCompleted {
                            habit.completedDate = Date()
                        } else {
                            habit.completedDate = nil
                        }
                        habitStore.updateHabit(habit)
                    }
                
                Divider()
                
                HStack {
                    VStack(alignment: .leading) {
                        Text("Current Streak")
                            .font(.system(size: 16, weight: .light, design: .serif))
                        Text("\(habit.calculateStreak())")
                            .font(.title)
                    }
                    Spacer()
                    VStack(alignment: .leading) {
                        Text("Longest Streak")
                            .font(.system(size: 16, weight: .light, design: .serif))
                        Text("\(habit.calculateLongestStreak())")
                            .font(.title)
                    }
                }.padding()
                
            }
            .padding([.leading,.trailing],20)
            .padding(.vertical,10)
            .navigationBarItems(trailing: Button("Done") {
                dismiss()
            })
        }
    }
}

struct HabitDetailView_Previews: PreviewProvider {
    static var previews: some View {
        HabitDetailView(habit: Habit(title: "Sample Habit", completedDates: [], startDate: Date().addingTimeInterval(-86400*7),reminderTime: Date()))
    }
}
