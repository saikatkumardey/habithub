//
//  ReminderConfiguration.swift
//  HabitTracker
//
//  Created by Saikat Kumar Dey on 06/07/23.
//

import Foundation
import SwiftUI

struct ReminderConfigurationView: View {
    
    @Binding var reminderTime: Date
    @Binding private var isReminderEnabled: Bool
    @State private var formattedReminderTime: String
    var title: String = "Reminder"
    
    
    let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter
    }()
    
    init(reminderTime: Binding<Date>, isReminderEnabled: Binding<Bool>, title: String = "Reminder") {
        self._reminderTime = reminderTime
        self._isReminderEnabled = isReminderEnabled
        self._formattedReminderTime = State(initialValue: timeFormatter.string(from: reminderTime.wrappedValue))
        self.title = title
    }
    
    var body: some View {
        HStack{
            Text(title)
               
            Toggle("", isOn: $isReminderEnabled)
                .frame(width: 60)
                .foregroundColor(.primary)
                .onChange(of: isReminderEnabled) { value in
                    if !value {
                        reminderTime = Calendar.current.date(bySettingHour: 8, minute: 0, second: 0, of: reminderTime)!
                    }
                }
                .buttonStyle(.borderless)
            
            
            if isReminderEnabled {
                DatePicker("",
                           selection: $reminderTime,
                           displayedComponents: .hourAndMinute)
                .datePickerStyle(.compact)
                .labelsHidden()
                .onChange(of: reminderTime) { value in
                    formattedReminderTime = timeFormatter.string(from: value)
                }
                .buttonStyle(.borderless)
            }
        }
    }
}

struct ReminderConfigurationView_Previews: PreviewProvider {
    static var previews: some View {
        ReminderConfigurationView(reminderTime: .constant(Date()), isReminderEnabled: .constant(false))
            .padding()
    }
}
