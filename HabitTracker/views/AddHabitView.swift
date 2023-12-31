//
//  AddHabitSheet.swift
//  HabitTracker
//
//  Created by Saikat Kumar Dey on 01/07/23.
//

import SwiftUI


struct AddHabit: View {
    @Environment(\.dismiss) var dismiss
    // theme
    @Environment(\.colorScheme) var colorScheme
    
    @EnvironmentObject var habit: Habit
    //    @FocusState private var isTextFieldFocused: Bool
    @State private var isPickingSymbol: Bool = false
    @State private var showingPopover = false
    
    var isEditing: Bool = false
    
    let onAdd: () -> Void
    
    var body: some View {
        NavigationStack {
            VStack(alignment:.leading, spacing: 10) {
                TextField(isEditing ? habit.title : "What do you want to get better at?", text: $habit.title)
                    .padding()
                    .lineLimit(2)
                    .background(Color(.systemGray5))
                    .cornerRadius(10)
                
                HStack{
                    DatePicker(
                        "",
                        selection: $habit.startDate,
                        displayedComponents: [.date, .hourAndMinute]
                    )
                    .onChange(of: habit.startDate) { _ in
                        habit.clearCompletedDates()
                    }
                    .labelsHidden()
                    .onAppear{
                        UIDatePicker.appearance().minuteInterval = 15
                    }
                    Button(action: {
                        showingPopover = true
                    }) {
                        Image(systemName: "info.circle")
                            .foregroundColor(.blue)
                    }
                    .popover(isPresented: $showingPopover, attachmentAnchor: .point(.center), arrowEdge: .top) {
                        Text("Set up a start date and reminder time.")
                            .presentationCompactAdaptation(.none)
                            .padding()
                    }
                }
                Spacer()
                SymbolPicker()
                    .environmentObject(habit)
            }
            .padding(.horizontal)
            .navigationBarTitle(isEditing ? "Edit Habit" : "Add Habit")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                trailing: Button(isEditing ? "Done" : "Create") {
                    onAdd()
                    dismiss()
                }.disabled($habit.title.wrappedValue.isEmpty))
        }
        .gesture(TapGesture().onEnded{
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        })
    }
}

struct AddHabitSheet_Previews: PreviewProvider {
    static var previews: some View {
        AddHabit() {
        }
        .environmentObject(Habit())
        
    }
}
