//
//  HabitListView.swift
//  HabitTracker
//
//  Created by Saikat Kumar Dey on 09/07/23.
//

import SwiftUI

struct HabitListView: View {
    @EnvironmentObject var habitStore: HabitStore
    @State private var selectedHabit: Habit?
    @State private var showingHabitDetails = false
    
    var habits: [Habit]
    
    var body: some View {
        List {
            ForEach(habits, id: \.id) { habit in
                Button(action: {
                    self.selectedHabit = habit
                    self.showingHabitDetails = true
                }) {
                    HabitRow(habit: habit)
                        .environmentObject(habitStore)
                }
            }.onDelete(perform: deleteHabit)
        }
        .listStyle(.insetGrouped)
        .sheet(item: $selectedHabit) { habit in
            NavigationView {
                HabitDetailView(habit: habit)
                    .environmentObject(habitStore)
            }
        }
        .padding(.vertical,10)
    }
    
    private func deleteHabit(at offsets: IndexSet) {
        print("deleting habit at offsets \(offsets)")
        offsets.forEach { index in
            let habit = habits[index]
            habitStore.deleteHabit(habit)
            habitStore.cancelNotification(for: habit)
        }
    }
}
#Preview {
    HabitListView(habits: HabitStore().habits)
        .environmentObject(HabitStore())

}
