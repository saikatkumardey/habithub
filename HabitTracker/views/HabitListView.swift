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
        NavigationStack {
            List {
                ForEach(habits, id: \.id) { habit in
                    ZStack(alignment: .bottom){
                        Button(action: {
                            self.selectedHabit = habit
                            self.showingHabitDetails = true
                        }) {
                            HStack(alignment: .center){
                                HabitRow(habit: habit)
                                    .environmentObject(habitStore)
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.gray)
                            }
                        }
                        //                            .buttonStyle(.bordered)
                        .padding(.vertical, 10)
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
                                        .labelStyle(.titleAndIcon)
                                } else {
                                    Label("Complete", systemImage: "checkmark.circle")
                                        .labelStyle(.titleAndIcon)
                                }
                            }
                            .tint(.green)
                            
                            Button(action: {
                                deleteHabit(at: habit)
                            }) {
                                Label("Delete", systemImage: "trash")
                                    .labelStyle(.titleAndIcon)
                            }
                            .tint(.red)
                        }
                        Spacer()
                    }
                }
            }
            .listStyle(.plain)
//            .shadow(radius: 5)
            .fullScreenCover(item: $selectedHabit) { habit in
                NavigationView {
                    HabitDetailView(habit: habit)
                        .environmentObject(habitStore)
                }
            }
            .padding(.vertical,10)
        }
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
struct HabitListView_Previews: PreviewProvider {
    static var previews: some View {
        HabitListView(habits: HabitStore().habits)
            .environmentObject(HabitStore())
    }
}
