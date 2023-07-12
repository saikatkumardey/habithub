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
                    .swipeActions {
                        Button(action: {
                            if habit.isHabitCompleted {
                                habitStore.markHabitAsNotCompleted(habit)
                            } else {
                                habitStore.markHabitAsCompleted(habit)
                            }
                        }) {
                            if habit.isHabitCompleted {
                                Label("Not Complete", systemImage: "xmark.circle.fill")
                                    .background(.gray)
                            } else {
                                Label("Complete", systemImage: "checkmark.circle")
                            }
                        }
                        
                        Button(action: {
                            deleteHabit(at: habit)
                        }) {
                            Label("Delete", systemImage: "trash")
                        }
                        .tint(.red)
                    }
                }
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
    
    
    private func completeHabit(at habit: Habit) {
        print("completing habit \(habit)")
        habitStore.markHabitAsCompleted(habit)
        habitStore.cancelNotification(for: habit)
    }
    
    private func deleteHabit(at habit: Habit) {
        print("deleting habit \(habit)")
        habitStore.deleteHabit(habit)
        habitStore.cancelNotification(for: habit)
    }
    
}
#Preview {
    HabitListView(habits: HabitStore().habits)
        .environmentObject(HabitStore())
    
}
