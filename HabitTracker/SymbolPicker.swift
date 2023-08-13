//
//  SymbolPicker.swift
//  HabitTracker
//
//  Created by Saikat Kumar Dey on 27/07/23.
//

import SwiftUI


struct SymbolPicker: View {
    @EnvironmentObject var habit: Habit
    @State private var selectedColor: Color = ColorOptions.default
    @Environment(\.dismiss) private var dismiss
    @State private var symbolNames = HabitSymbols.symbolNames
    @State private var searchInput = ""
    
    var columns = Array(repeating: GridItem(.flexible()), count: 6)

    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button {
                    dismiss()
                } label: {
                    Text("Done")
                }
                .padding()
            }
            VStack {
                Image(systemName: habit.symbol)
                    .font(.title)
                    .imageScale(.large)
                    .foregroundColor(selectedColor)
                Text("some description1, desc2")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding()

            HStack {
                ForEach(ColorOptions.all, id: \.self) { color in
                    Button {
                        selectedColor = color
                        habit.color = color
                    } label: {
                        Circle()
                            .foregroundColor(color)
                    }
                }
            }
            .padding(.horizontal)
            .frame(height: 40)

            Divider()

            // Add TextField for search input
            TextField("Search symbols", text: $searchInput)
                .padding(.horizontal)

            ScrollView {
                LazyVGrid(columns: columns) {
                    // Filter symbolNames based on searchInput
                    ForEach(symbolNames.filter { symbolItem in
                        let trimmedSearchInput = searchInput.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
                        return trimmedSearchInput.isEmpty || symbolItem.contains(trimmedSearchInput)
                    }, id: \.self) { symbolItem in
                        Button {
                            habit.symbol = symbolItem
                        } label: {
                            Image(systemName: symbolItem)
                                .sfSymbolStyling()
                                .foregroundColor(selectedColor)
                                .padding(5)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .drawingGroup()
            }
        }
        .onAppear {
            selectedColor = habit.color
        }
    }
}

// preview
struct SymbolPicker_Previews: PreviewProvider {
    static var previews: some View {
        let habit = Habit(title: "Test")
        SymbolPicker()
            .environmentObject(habit)
    }
}

