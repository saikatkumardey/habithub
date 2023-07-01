//
//  AddHabitSheet.swift
//  HabitTracker
//
//  Created by Saikat Kumar Dey on 01/07/23.
//

import SwiftUI

struct AddHabitSheet: View {
    @Environment(\.dismiss) var dismiss
    
    @Binding var newHabitTitle: String
    @Binding var newHabitStartDate: Date
    
    let onAdd: () -> Void

    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                TextField("Exercise for 10 mins every day", text: $newHabitTitle)
                    .padding(5)
                    .font(.title2)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                DatePicker("Start Date", selection: $newHabitStartDate, displayedComponents: .date)
                    .datePickerStyle(.graphical)
                    .padding(10)
                Spacer()
                
            }
            .padding()
            .navigationBarTitle("Add Habit")
            .navigationBarItems(leading: Button("Cancel") {
                dismiss()
            }, trailing: Button("Create") {
                onAdd()
                dismiss()
            })
        }
    }
}

struct AddHabitSheet_Previews: PreviewProvider {
    static var previews: some View {
        AddHabitSheet(newHabitTitle: .constant(""), newHabitStartDate: .constant(Date())) {
            // Action
        }
    }
}
