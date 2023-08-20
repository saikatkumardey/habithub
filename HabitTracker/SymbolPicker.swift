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
    @State private var searchInput = ""
    var filteredSymbols: [String] {
        if searchInput.isEmpty {
            return Array(HabitSymbols.symbolDescriptions.keys)
        } else {
            return HabitSymbols.symbolDescriptions.filter { key, value in
                value.lowercased().contains(searchInput.lowercased())
            }.map { $0.key }
        }
    }
    
    var columns = Array(repeating: GridItem(.flexible()), count: 3)

    var body: some View {
        VStack {
            VStack {
                Image(systemName: habit.symbol)
                    .font(.title)
                    .fontWeight(.heavy)
                    .imageScale(.large)
                    .foregroundColor(selectedColor)
                Text(HabitSymbols.symbolDescriptions[habit.symbol] ?? "")
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

            // Add TextField for search input
            TextField("Search symbols", text: $searchInput)
                .padding()
                .background(Color(.systemGray5))
                .cornerRadius(10)

            ScrollView {
                LazyVGrid(columns: columns) {
                    // Filter filteredSymbols based on searchInput
                    ForEach(filteredSymbols, id: \.self) { symbolItem in
                        Button(action: {
                            habit.symbol = symbolItem
                        }) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 10)
                                    .foregroundColor(.gray.opacity(0.1))
                                    .frame(width: 80, height: 80)
                                Image(systemName: symbolItem)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 40, height: 40)
                                    .foregroundColor(selectedColor)
                            }
                        }
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


