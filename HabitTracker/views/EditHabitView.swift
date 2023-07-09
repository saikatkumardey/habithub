//
//  EditHabitView.swift
//  HabitTracker
//
//  Created by Saikat Kumar Dey on 09/07/23.
//

import SwiftUI

struct EditHabit: View {
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var habitStore: HabitStore
    @ObservedObject var habit: Habit
    @FocusState private var isTextFieldFocused : Bool
    @State var habitTitle: String
    
    init(habit: Habit) {
        self.habit = habit
        self._habitTitle = State(initialValue: habit.title)
    }
    
    
    var body: some View {
        
        NavigationStack{
            VStack(alignment:.center,spacing: 30) {
                HStack {
                    Text("I will")
                        .foregroundColor(.primary)
                    Spacer()
                }
                TextField("Exercise for 10 mins every day", text: $habitTitle)
                    .focused($isTextFieldFocused)
                    .font(.system(size: 20))
                    .foregroundColor(.primary)
//                    .onChange(of: habit.title) { newValue in
//                        habitStore.updateHabit(habit)
//                    }
                HStack{
                    Text("every day")
                        .foregroundColor(.primary)
                    Spacer()
                }
                DatePicker("starting from", selection: $habit.startDate, displayedComponents: .date)
                    .datePickerStyle(.automatic)
                    .foregroundColor(.primary)
//                    .onChange(of: habit.startDate) { newValue in
//                        habitStore.updateHabit(habit)
//                    }
                ReminderConfigurationView(reminderTime: $habit.reminderTime, isReminderEnabled: $habit.isReminderEnabled)
                    .foregroundColor(.primary)
//                    .onChange(of: habit.reminderTime) { newValue in
//                        habitStore.updateHabit(habit)
//                    }
            }
            .padding(20)
            .navigationBarItems(leading:
                                    Button("Cancel") {
                dismiss()
            }, trailing: Button("Done") {
                habit.title = habitTitle
                habitStore.updateHabit(habit)
                dismiss()
            }.disabled(habitTitle.isEmpty)
            )
            .task {
                isTextFieldFocused = true
            }
        }.environment(\.font, .system(size:30, weight: .light, design: .rounded))
    }
}

#Preview {
    EditHabit(habit: Habit(title: "Exercise for 10 mins every day", completedDates: [], startDate: Date(), reminderTime: Date(), isReminderEnabled: true))
}
