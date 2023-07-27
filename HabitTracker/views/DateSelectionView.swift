//
//  DateSelectionView.swift
//  HabitTracker
//
//  Created by Saikat Kumar Dey on 18/07/23.
//

import SwiftUI

struct DateSelectionView: View {
    var title: String = ""
    @Binding var selectedDate: Date
    @State var showDatePicker = false
    @FocusState var isFocused: Bool
    
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }
        
    var body: some View {
        VStack {
            HStack{
                Text(title)
                    .foregroundColor(.primary)
                    .padding(.trailing,30)
                Button(action: {
                    withAnimation {
                        showDatePicker.toggle()
                    }
                }) {
                    HStack{
                        Image(systemName: "calendar")
                        Text("\(selectedDate, formatter: dateFormatter)")
                    }
                }
                .buttonStyle(.borderless)
            }
            if showDatePicker {
                DatePicker(
                    "",
                    selection: $selectedDate,
                    displayedComponents: [.date]
                )
                .labelsHidden()
                .datePickerStyle(.wheel)
                .focused($isFocused)
                .onChange(of: isFocused) { value in
                    withAnimation {
                        showDatePicker.toggle()
                    }
                }
            }
        }
        .onTapGesture {
            withAnimation {
                showDatePicker = false
            }
        }
    }
}

struct DateSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        DateSelectionView(title: "Started on", selectedDate: .constant(Date()))
    }
}
