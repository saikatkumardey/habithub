//
//  HabitDetailView.swift
//  HabitTracker
//
//  Created by Saikat Kumar Dey on 01/07/23.
//

import SwiftUI

struct HabitDetailView: View {
    @ObservedObject var habit: Habit
    
    @State private var isHabitCompleted: Bool = false

    var body: some View {
        VStack {
            TextField("Habit title", text: $habit.title)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())

            HabitGrid(habit: habit, today: Date())
                .padding(.top)
            
            // Check box button for marking the habit as complete
            Toggle(isOn: $isHabitCompleted) {
                Text("Mark as complete")
                    .font(.title3)
                    .padding()
            }
            .padding(20)
            
        }
        .navigationBarTitle("Habit Details")
    }
}

struct HabitDetailView_Previews: PreviewProvider {
    static var previews: some View {
        HabitDetailView(habit: Habit(title: "Sample Habit", count: 0, completedDates: []))
    }
}
