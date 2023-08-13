//
//  AddHabitSheet.swift
//  HabitTracker
//
//  Created by Saikat Kumar Dey on 01/07/23.
//

import SwiftUI
import EmojiKit


struct AddHabit: View {
    @Environment(\.dismiss) var dismiss
    
    @EnvironmentObject var habit: Habit
    @FocusState private var isTextFieldFocused: Bool
    @State private var isPickingSymbol: Bool = false
    
    let onAdd: () -> Void
    
    var body: some View {
        NavigationStack {
            VStack(alignment:.leading, spacing: 10) {
                HStack{
                    Button {
                        isPickingSymbol.toggle()
                    } label: {
                        //                        Image(systemName: habit.symbol)
                        //                            .sfSymbolStyling()
                        //                            .foregroundColor(habit.color)
                        Text(habit.symbol)
                            .font(.system(size: 40))
                    }
                    .buttonStyle(.borderless)
                    .padding(.horizontal, 5)
                    TextField("What do you want to get better at?", text: $habit.title, axis: .vertical)
                        .lineLimit(2)
                        .focused($isTextFieldFocused)
                        .font(.system(size: 20, weight: .light, design: .rounded))
                        .fontWeight(.light)
                }
                HStack{
                    DatePicker(
                        "",
                        selection: $habit.startDate,
                        displayedComponents: [.date, .hourAndMinute]
                    )
                    .labelsHidden()
                    .onAppear{
                        UIDatePicker.appearance().minuteInterval = 15
                    }
                }
            }
            .sheet(isPresented: $isPickingSymbol) {
                //                SymbolPicker()
                //                    .environmentObject(habit)
                EmojiPickerView() { name, value in
                    habit.symbol = name
                }
                
            }
            .padding()
            .navigationBarTitle("Add Habit")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(leading: Button("Cancel") {
                dismiss()
            }, trailing: Button("Create") {
                onAdd()
                dismiss()
            }.disabled($habit.title.wrappedValue.isEmpty))
            .task {
                isTextFieldFocused = true
            }
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
