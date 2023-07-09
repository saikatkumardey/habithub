//
//  Habit.swift
//  HabitTracker
//
//  Created by Saikat Kumar Dey on 01/07/23.
//

import Foundation
import SwiftUI

enum ReminderFrequency: String, Codable {
    case daily
    case weekly
    case monthly
}


class Habit: ObservableObject, Identifiable, Codable {
    
    @Published var id: UUID = UUID()
    @Published var title: String
    @Published var completedDates: Set<DateComponents>
    @Published var maxStreak: Int = 0
    @Published var startDate: Date = Date()
    @Published var isHabitCompleted: Bool = false
    @Published var completedDate: Date?
    @Published var reminderTime: Date
    @Published var reminderFrequency: ReminderFrequency?
    @Published var isReminderEnabled: Bool = false
    
    init(title: String, completedDates: Set<DateComponents>, startDate: Date = Date(), isCompleted: Bool = false, completedDate: Date? = nil, reminderTime: Date, reminderFrequency: ReminderFrequency? = nil, isReminderEnabled: Bool = false) {
        self.title = title
        self.completedDates = completedDates
        self.startDate = startDate
        self.isHabitCompleted = isCompleted
        self.completedDate = completedDate
        self.reminderTime = reminderTime
        self.reminderFrequency = reminderFrequency
        self.isReminderEnabled = isReminderEnabled
        
    }
    
    enum CodingKeys: String, CodingKey {
        case id, title, completedDates, startDate, isHabitCompleted, completedDate, reminderTime, reminderFrequency, isReminderEnabled
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        completedDates = try container.decode(Set<DateComponents>.self, forKey: .completedDates)
        startDate = try container.decode(Date.self, forKey: .startDate)
        isHabitCompleted = try container.decode(Bool.self, forKey: .isHabitCompleted)
        completedDate = try container.decode(Date?.self, forKey: .completedDate)
        reminderTime = try container.decode(Date.self, forKey: .reminderTime)
        reminderFrequency = try container.decode(ReminderFrequency?.self, forKey: .reminderFrequency)
        isReminderEnabled = try container.decode(Bool.self, forKey: .isReminderEnabled)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encode(completedDates, forKey: .completedDates)
        try container.encode(startDate, forKey: .startDate)
        try container.encode(isHabitCompleted, forKey: .isHabitCompleted)
        try container.encode(completedDate, forKey: .completedDate)
        try container.encode(reminderTime, forKey: .reminderTime)
        try container.encode(reminderFrequency, forKey: .reminderFrequency)
        try container.encode(isReminderEnabled, forKey: .isReminderEnabled)
    }
    
    func completedDatesSet() -> Set<Date> {
        var dates = Set<Date>()
        for dateComponent in completedDates {
            if let date = Calendar.current.date(from: dateComponent) {
                dates.insert(date)
            }
        }
        return dates
    }
    
    
    func isCompleted(on date: Date) -> Bool {
        let noTimeDate = date.startOfDay
        let completedDates = completedDatesSet()
        return completedDates.contains(noTimeDate)
    }
    
    func calculateStreak(from: Date = Date()) -> Int {
        var streak = 0
        var date = from
        while isCompleted(on: date) {
            streak += 1
            date = Calendar.current.date(byAdding: .day, value: -1, to: date)!
        }
        return streak
    }
    
    // dfs
    func calculateLongestStreak() -> Int {
        var longestStreak = 0
        var date = Date()
        while date >= startDate {
            if isCompleted(on: date) {
                let streak = calculateStreak(from: date)
                if streak > longestStreak {
                    longestStreak = streak
                }
                date = Calendar.current.date(byAdding: .day, value: -streak, to: date)!
            } else {
                date = Calendar.current.date(byAdding: .day, value: -1, to: date)!
            }
        }
        return longestStreak
        
    }
    
    // consider from start date only, min(n,today-startDate)
    func lastNdayCells(n: Int) -> [Int] {
        var cells = [Int]()
        var date = Date()
        var i = 0
        while i < n && date >= startDate {
            if isCompleted(on: date) {
                cells.append(1)
            } else {
                cells.append(0)
            }
            date = Calendar.current.date(byAdding: .day, value: -1, to: date)!
            i += 1
        }
        return cells.reversed()
    }
    
    func markDateCompleted(date: Date) {
        let noTimeDate = date.startOfDay
        if isCompleted(on: noTimeDate) {
            return
        }
        completedDates.insert(Calendar.current.dateComponents([.year, .month, .day], from: noTimeDate))
    }
    
    func toggleCompletion() {
        isHabitCompleted.toggle()
        if isHabitCompleted {
            completedDate = Date()
        } else {
            completedDate = nil
        }
    }
}

extension Date {
    var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }
}

extension UserDefaults {
    private static let habitsKey = "habits"
    
    func saveHabits(_ habits: [Habit]) {
        if let encodedData = try? JSONEncoder().encode(habits) {
            set(encodedData, forKey: UserDefaults.habitsKey)
        }
    }
    
    func loadHabits() -> [Habit] {
        if let data = data(forKey: UserDefaults.habitsKey) {
            if let decodedHabits = try? JSONDecoder().decode([Habit].self, from: data) {
                return decodedHabits
            }
        }
        return []
    }
}
