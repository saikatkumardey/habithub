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
    @State private var newHabit: Habit = Habit()
    @State private var showDeleteConfirmationAlert = false
    @State private var sortOrder = SortOrder.startDate
    
    enum SortOrder {
        case startDate, totalCompleted, longestStreak, currentStreak, reminderTime
    }
    
    
    var sortedHabits: [Habit] {
        switch sortOrder {
        case .startDate:
            return habits.sorted { $0.startDate.startOfDay < $1.startDate.startOfDay }
        case .reminderTime:
            return habits.sorted {
                // reminderTime is the HH:MM component of startDate
                let firstTime = Calendar.current.dateComponents([.hour, .minute], from: $0.startDate)
                let secondTime = Calendar.current.dateComponents([.hour, .minute], from: $1.startDate)
                // convert firstTime to seconds
                let firstTimeInSeconds = firstTime.hour! * 3600 + firstTime.minute! * 60
                let secondTimeInSeconds = secondTime.hour! * 3600 + secondTime.minute! * 60
                return firstTimeInSeconds < secondTimeInSeconds
            }
        case .totalCompleted:
            return habits.sorted { $0.calculateTotalCompleted() > $1.calculateTotalCompleted() }
        case .longestStreak:
            return habits.sorted { $0.calculateLongestStreak() > $1.calculateLongestStreak() }
        case .currentStreak:
            return habits.sorted { $0.calculateStreak() > $1.calculateStreak() }
        }
    }
    
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
                    }
                }
            }else{
                
                List {
                    HStack{
                        Spacer()
                        Picker("Sort by", selection: $sortOrder) {
                            Text("Date Added").tag(SortOrder.startDate)
                            Text("Reminder Time").tag(SortOrder.reminderTime)
                            Text("Completed days").tag(SortOrder.totalCompleted)
                            Text("Longest Streak").tag(SortOrder.longestStreak)
                            Text("Current Streak").tag(SortOrder.currentStreak)
                        }
                        .pickerStyle(.menu)
                        .labelsHidden()
                        .fontDesign(.rounded)
                    }
                    ForEach(sortedHabits, id: \.id) { habit in
                        NavigationLink(
                            destination: HabitDetailView()
                                .environmentObject(habit)
                                .environmentObject(habitStore)
                        ){
                            HStack(alignment: .top) {
                                HabitRow(habit: habit)
                                    .environmentObject(habitStore)
                                Spacer()
                                VStack{
                                    Image(systemName: habit.isHabitCompleted ? "checkmark.circle.fill": "checkmark.circle")
                                        .font(.system(size: 10, weight: .light))
                                        .foregroundColor(.green)
                                    
                                    Text("\(habit.calculateTotalCompleted())")
                                        .foregroundColor(.green)
                                        .fontWeight(.thin)
                                }
                                VStack{
                                    Image(systemName: habit.isHabitCompleted ? "flame.fill": "flame")
                                        .font(.system(size: 10, weight: .light))
                                        .foregroundColor(.pink)
                                    
                                    Text("\(habit.calculateStreak())")
                                        .foregroundColor(.pink)
                                        .fontWeight(.thin)
                                }
                                VStack{
                                    Image(systemName:  habit.isHabitCompleted ? "trophy.fill": "trophy")
                                        .font(.system(size: 10, weight: .light))
                                        .foregroundColor(.orange)
                                    
                                    Text("\(habit.calculateLongestStreak())")
                                        .foregroundColor(.orange)
                                        .fontWeight(.thin)
                                }
                            }
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
                                selectedHabit = habit
                                self.showDeleteConfirmationAlert = true
                            }) {
                                Label("Delete", systemImage: "trash")
                                    .labelStyle(.titleAndIcon)
                            }
                            .tint(.red)
                        }
                    }
                }
                .alert(isPresented: $showDeleteConfirmationAlert) {
                    Alert(
                        title: Text("Delete Habit"),
                        message: Text("Are you sure you want to delete this habit?"),
                        primaryButton: .destructive(Text("Delete")) {
                            if let habit = selectedHabit {
                                deleteHabit(at:habit)
                            }
                        },
                        secondaryButton: .cancel()
                    )
                }
                .toolbar {
                    ToolbarItemGroup(placement: .navigationBarTrailing) {
                        Button {
                            self.showingAddHabitSheet = true
                        } label: {
                            Image(systemName: "plus")
                                .font(.system(size:10,weight: .light))
                                .foregroundColor(.white)
                                .padding(8)
                                .background(Circle().fill(.primary))
                        }
                    }
                }
            }
        }
        .sheet(isPresented: $showingAddHabitSheet) {
            AddHabit(){
                addHabit()
            }
            .environmentObject(newHabit)
//            .presentationDetents([.fraction(0.3)])
        }
    }
    
    func addHabit() {
        print("Adding new habit: \(newHabit.title)")
        habitStore.addHabit(newHabit)
        habitStore.scheduleNotification(for: newHabit, at: newHabit.startDate)
        newHabit = Habit()
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
