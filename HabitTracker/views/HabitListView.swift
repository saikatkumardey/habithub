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
    @State private var showingAddHabitSheet = false
    @State private var newHabitTitle = ""
    @State private var newHabitStartDate = Date()
    @State private var newHabitReminderTime = Date().startOfDay.addingTimeInterval(8*60*60)
    @State private var newHabitReminderEnabled : Bool = false
    
    
    var habits: [Habit]
    let isCompleted: Bool
    
    var body: some View {
        Group{
            if habits.isEmpty{
                HStack(alignment:.center){
                    Text("Please add a habit.")
                        .font(.system(size: 40, weight: .ultraLight, design: .rounded))
                        .multilineTextAlignment(.center)
                    Button(action: {
                        self.showingAddHabitSheet = true
                    }) {
                        Image(systemName: "plus")
                            .font(.system(size:40,weight: .light))
                            .foregroundColor(.white)
                            .padding(8)
                            .background(Circle().fill(.primary))
                            .shadow(radius: 5)
                    }
                }
            }else{
                List {
                    ForEach(habits, id: \.id) { habit in
                        NavigationLink(
                            destination: HabitDetailView(habit: habit)
                                .environmentObject(habitStore)
                        ){
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
                                    Label("Not Complete", systemImage: "arrow.uturn.left.circle.fill")
                                        .labelStyle(.titleAndIcon)
                                } else {
                                    Label("Complete", systemImage: "checkmark.circle")
                                        .labelStyle(.titleAndIcon)
                                }
                            }
                            .tint(habit.isHabitCompleted ? .gray : .green)
                            
                            Button(action: {
                                deleteHabit(at: habit)
                            }) {
                                Label("Delete", systemImage: "trash")
                                    .labelStyle(.titleAndIcon)
                            }
                            .tint(.red)
                        }
                    }
                    //            .listRowSeparator(.hidden)
                    //            .listRowBackground(
                    //                RoundedRectangle(cornerRadius: 5)
                    //                    .foregroundColor(.teal.opacity(0.3))
                    //                    .shadow(color:.white.opacity(0.1), radius: 5)
                    //                    .padding(.vertical, 2)
                    //
                    //            )
                }
                .toolbar {
                    if !isCompleted {
                        ToolbarItem {
                            Button {
                                self.showingAddHabitSheet = true
                            } label: {
                                Image(systemName: "plus")
                                    .font(.system(size:20,weight: .light))
                                    .foregroundColor(.white)
                                    .padding(8)
                                    .background(Circle().fill(.primary))
                                    .shadow(radius: 5)
                            }
                        }
                    }
                }
                .shadow(color:.gray.opacity(0.7), radius: 5)
            }
        }
        .sheet(isPresented: $showingAddHabitSheet) {
            AddHabit(newHabitTitle: $newHabitTitle,
                     newHabitStartDate: $newHabitStartDate,
                     newHabitReminderTime: $newHabitReminderTime,
                     newHabitReminderEnabled: $newHabitReminderEnabled
            ){
                addHabit()
            }
            .presentationDetents([.fraction(0.4)])
        }
    }
    
    func addHabit() {
        let newHabit = Habit(title: newHabitTitle,
                             completedDates: [],
                             startDate: newHabitStartDate,
                             reminderTime: newHabitReminderTime,
                             isReminderEnabled: newHabitReminderEnabled
        )
        
        print("Adding new habit: \(newHabit.title)")
        habitStore.addHabit(newHabit)
        habitStore.listHabits()
        if newHabitReminderEnabled {
            habitStore.scheduleNotification(for: newHabit, at: newHabitReminderTime)
        }
        newHabitTitle = ""
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
        HabitListView(habits: HabitStore().habits, isCompleted: false)
            .environmentObject(HabitStore())
    }
}
