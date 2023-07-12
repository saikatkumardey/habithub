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
    
    let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter
    }()
    
    init(reminderTime: Binding<Date>, isReminderEnabled: Binding<Bool>) {
        self._reminderTime = reminderTime
        self._isReminderEnabled = isReminderEnabled
        self._formattedReminderTime = State(initialValue: timeFormatter.string(from: reminderTime.wrappedValue))
    }
    
    var body: some View {
        VStack(spacing:10) {
            HStack(alignment: .center){
                VStack(alignment:.leading){
                    Text("Remind me")
                    if isReminderEnabled {
                        Text(formattedReminderTime)
                            .foregroundColor(.secondary)
                            .font(.caption)
                    }
                }
                Toggle("", isOn: $isReminderEnabled)
            }
            if isReminderEnabled {
                DatePicker("Time",
                           selection: $reminderTime,
                           displayedComponents: .hourAndMinute)
                .datePickerStyle(.compact)
                .onChange(of: reminderTime) { value in
                    formattedReminderTime = timeFormatter.string(from: value)
                }
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
