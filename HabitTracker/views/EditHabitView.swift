//
//  EditHabitView.swift
//  HabitTracker
//
//  Created by Saikat Kumar Dey on 09/07/23.
//

import SwiftUI

struct EditHabitView: View {
    
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
            VStack(spacing: 20) {
                HStack {
                    Text("I will")
                        .foregroundColor(.primary)
                    Spacer()
                }
                TextField("Exercise for 10 mins every day", text: $habitTitle, axis: .vertical)
                    .padding()
                    .lineLimit(/*@START_MENU_TOKEN@*/2/*@END_MENU_TOKEN@*/)
                    .focused($isTextFieldFocused)
                    .font(.system(size: 20))
                    .foregroundColor(.primary)
                HStack{
                    Text("every day")
                        .foregroundColor(.primary)
                    Spacer()
                }
                DatePicker("starting from", selection: $habit.startDate,displayedComponents: .date)
                .datePickerStyle(.automatic)
                .foregroundColor(.primary)
                
                ReminderConfigurationView(reminderTime: $habit.reminderTime, isReminderEnabled: $habit.isReminderEnabled)
                    .foregroundColor(.primary)
                Spacer()
                
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
            .gesture(TapGesture().onEnded{
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            })
    }
}

// preview
struct EditHabit_Previews: PreviewProvider {
    static var previews: some View {
            EditHabitView(habit: Habit(title: "Exercise for 10 mins every day", completedDates: [], startDate: Date(), reminderTime: Date(), isReminderEnabled: true))
    }
}
