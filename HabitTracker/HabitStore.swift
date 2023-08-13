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
    
    
    func updateHabit(_ habit: Habit) {
        if let index = habits.firstIndex(where: { $0.id == habit.id }) {
            print("updating habit \(habit.title), id \(habit.id.uuidString)")
            print("earlier start-date \(habits[index].startDate), new start-date \(habit.startDate)")
            if habit.isHabitCompleted{
                cancelNotification(for: habits[index])
            }
            print("cancelling/schedule notification for habit \(habit.title)")
            cancelNotification(for: habits[index])
            scheduleNotification(for: habit, at: habit.startDate)
            habits[index] = habit
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
    
    func markHabitAsNotCompleted(_ habit: Habit) {
        habit.isHabitCompleted = false
        habit.completedDate = nil
        print("habit \(habit.title) not completed")
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
    
    func scheduleNotification(for habit: Habit, at date: Date) {
        
        UNUserNotificationCenter.current().getPendingNotificationRequests { (requests) in
            print("requests = \(requests)")
            if requests.contains(where: { $0.identifier == habit.id.uuidString }) {
                print("Notification already scheduled for habit: \(habit.title), id = \(habit.id.uuidString)")
                return
            }
        }
        
        let content = UNMutableNotificationContent()
        content.title = "Did you complete your habit today?"
        content.body = "\(habit.title)"
        content.sound = UNNotificationSound.default
        content.categoryIdentifier = "HABIT_REMINDER"
        content.userInfo = ["habitId": habit.id.uuidString]
        
        let calendar = Calendar.current
        var dateComponents = calendar.dateComponents([.hour,.minute],from: date)
        dateComponents.hour = dateComponents.hour
        dateComponents.minute = dateComponents.minute
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
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
