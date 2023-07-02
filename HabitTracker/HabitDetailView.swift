//
//  HabitDetailView.swift
//  HabitTracker
//
//  Created by Saikat Kumar Dey on 01/07/23.
//

import SwiftUI

struct HabitDetailView: View {
    @EnvironmentObject var habitStore: HabitStore
    @ObservedObject var habit: Habit

    var body: some View {
        VStack {
            // justify Text
            TextField("Habit title", text: $habit.title)
                .font(.system(size: 24, weight: .light, design: .serif))
                .padding(.bottom)
            
            // Start Date Editable, make it beautiful
            DatePicker("Start Date", selection: $habit.startDate, displayedComponents: .date)
                .padding()
//                .foregroundColor(.accentColor)
                .background(Color(.secondarySystemBackground))
                .font(.system(size: 16, weight: .light, design: .serif))
            
            HabitGrid(habit: habit, today: Date())
                .padding(.top)
                .background(Color(.secondarySystemBackground))
            

            // Check box button for marking the habit as complete
            Toggle(isOn: $habit.isHabitCompleted) {
                Text("Mark as complete")
                    .font(.title3)
                    .padding()
            }
            .background(Color(.secondarySystemBackground))
            .onChange(of: habit.isHabitCompleted) { _ in
                habitStore.habitsChanged.toggle()
            }
            
            // Current Streak and Longest Streak stats
            
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
//        .navigationBarTitle("Habit")
        .padding([.leading,.trailing],20)
    }
}

struct HabitDetailView_Previews: PreviewProvider {
    static var previews: some View {
        HabitDetailView(habit: Habit(title: "Sample Habit", completedDates: []))
    }
}
