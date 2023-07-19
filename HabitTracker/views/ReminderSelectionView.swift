//
//  ReminderSelectionView.swift
//  HabitTracker
//
//  Created by Saikat Kumar Dey on 18/07/23.
//

import SwiftUI

struct ReminderSelectionView: View {
    var title: String = ""
    @Binding var reminderTime: Date
    @Binding var isReminderEnabled: Bool
    @State var showDatePicker = false
    @FocusState var isFocused: Bool
    
    let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter
    }()
    
        
    var body: some View {
        VStack {
            Button(action: {
                withAnimation {
                    showDatePicker.toggle()
                }
            }) {
                HStack{
                    if isReminderEnabled{
                        Image(systemName: "alarm.fill")
                            .foregroundColor(.primary)
                        Text("\(reminderTime, formatter: timeFormatter)")
                            .foregroundColor(.primary)
                    } else{
                        Image(systemName: "alarm")
                            .foregroundColor(.primary)
                    }
                }
            }
            .buttonStyle(.bordered)
            if showDatePicker {
//                ReminderConfigurationView(reminderTime: $reminderTime, isReminderEnabled: $isReminderEnabled)
//                    .focused($isFocused)
//                    .onChange(of: isFocused) { value in
//                        withAnimation {
//                            showDatePicker.toggle()
//                        }
//                    }
//                DatePicker("Time",
//                           selection: $reminderTime,
//                           displayedComponents: .hourAndMinute)
//                .datePickerStyle(.wheel)
//                .labelsHidden()
//                .datePickerStyle(.wheel)
//                .focused($isFocused)
//                .onChange(of: isFocused) { value in
//                    withAnimation {
//                        showDatePicker.toggle()
//                    }
//                }
            }
        }
        .padding()
        .onTapGesture {
            withAnimation {
                showDatePicker = false
            }
        }
    }
}

struct ReminderSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        ReminderSelectionView(title: "Reminder", reminderTime: .constant(Date()), isReminderEnabled: .constant(false))
            .padding()
    }
}
