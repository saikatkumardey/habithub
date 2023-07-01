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
    let onAdd: () -> Void

    var body: some View {
        NavigationView {
            VStack {
                TextField("Habit title", text: $newHabitTitle)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
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
        AddHabitSheet(newHabitTitle: .constant("")) {
            // Action
        }
    }
}
