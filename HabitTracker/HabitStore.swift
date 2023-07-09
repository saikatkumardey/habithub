//
//  HabitStore.swift
//  HabitTracker
//
//  Created by Saikat Kumar Dey on 08/07/23.
//

import SwiftUI
import Foundation


class HabitStore: ObservableObject {
    
    private let accessQueue = DispatchQueue(label: "com.saikatkumardey.habittracker.habitstore")
    
    init() {
        habits = UserDefaults.standard.loadHabits()
        print("HabitStore created with id:\(ObjectIdentifier(self)))")
    }
    
    @Published private(set) var habits: [Habit] {
        didSet {
            saveHabits()
        }
    }
    @Published var habitsChanged = false {
        didSet {
            habitsChanged = false
        }
    }
    
    
    func addHabit(_ habit: Habit) {
        accessQueue.sync {
            habits.append(habit)
        }
        print("added habit \(habit.title), id \(habit.id.uuidString)")
    }
    
    func removeHabit(at offsets: IndexSet) {
        habits.remove(atOffsets: offsets)
    }
    
    func updateHabit(_ habit: Habit) {
        print("updating habit \(habit.title), id \(habit.id.uuidString)")
        if let index = habits.firstIndex(where: { $0.id == habit.id }) {
            habits[index] = habit
        }
        if habit.isReminderEnabled {
            print("updating notification for habit \(habit.title)")
            scheduleNotification(for: habit, at: habit.reminderTime)
        } else {
            cancelNotification(for: habit)
        }
    }
    
    func getHabit(by id: UUID) -> Habit? {
        
        accessQueue.sync {
            for habit in habits {
                print("searching: habit \(habit.title), id \(habit.id.uuidString)")
                if habit.id == id {
                    return habit
                }
            }
            return nil
        }
    }
    
    func listHabits() {
        for habit in habits {
            print("habit \(habit.title), id \(habit.id.uuidString)")
        }
    }
    
    func markHabitAsCompleted(_ habit: Habit) {
        habit.isHabitCompleted = true
        habit.completedDate = Date()
        print("habit \(habit.title) completed on \(habit.completedDate ?? Date())")
        updateHabit(habit)
    }
    
    func markDayAsCompleted(_ habit: Habit, date: Date) {
        habit.markDateCompleted(date: date)
        updateHabit(habit)
    }
    
    
    func saveHabits() {
        UserDefaults.standard.saveHabits(habits)
    }
    
    func deleteHabit(_ habit: Habit) {
        if let index = habits.firstIndex(where: { $0.id == habit.id }) {
            habits.remove(at: index)
        }
    }
    
    func saveReminderTime(_ reminder: Date, forHabitID habitID: UUID){
        if let index = habits.firstIndex(where: { $0.id == habitID }) {
            habits[index].reminderTime = reminder
        }
    }
    
    func scheduleNotification(for habit: Habit, at date: Date) {
        
        let content = UNMutableNotificationContent()
        content.title = "Time for your habit!"
        content.body = "\(habit.title)"
        content.sound = UNNotificationSound.default
        content.categoryIdentifier = "HABIT_REMINDER"
        content.userInfo = ["habitId": habit.id.uuidString]
        
        let calendar = Calendar.current
        var dateComponents = calendar.dateComponents([.hour,.minute],from: date)
        dateComponents.hour = dateComponents.hour
        dateComponents.minute = dateComponents.minute
        
        //        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        
        let request = UNNotificationRequest(identifier: habit.id.uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            } else {
                print("Notification scheduled for habit: \(habit.title), id = \(habit.id.uuidString)")
            }
        }
    }
    
    func cancelNotification(for habit: Habit) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [habit.id.uuidString])
    }
}
