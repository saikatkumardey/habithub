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
    @Published var symbol: String = HabitSymbols.default
    @Published var color: Color = ColorOptions.default
    @Published var title: String = ""
    @Published var completedDates: Set<DateComponents> = []
    @Published var maxStreak: Int = 0
    @Published var startDate: Date = Date()
    @Published var isHabitCompleted: Bool = false
    @Published var completedDate: Date? = nil
    @Published var reminderFrequency: ReminderFrequency? = nil
    @Published var lastUpdated: Date = Date()
    
    init(title: String="", completedDates: Set<DateComponents>=[], startDate: Date = Date(), isCompleted: Bool = false, completedDate: Date? = nil) {
        self.title = title
        self.completedDates = completedDates
        self.startDate = startDate
        self.isHabitCompleted = isCompleted
        self.completedDate = completedDate
        self.lastUpdated = Date()
    }
    
    enum CodingKeys: String, CodingKey {
        case id, title, completedDates, startDate, isHabitCompleted, completedDate, reminderFrequency, lastUpdated, symbol, color
        
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        completedDates = try container.decode(Set<DateComponents>.self, forKey: .completedDates)
        startDate = try container.decode(Date.self, forKey: .startDate)
        isHabitCompleted = try container.decode(Bool.self, forKey: .isHabitCompleted)
        completedDate = try container.decode(Date?.self, forKey: .completedDate)
        reminderFrequency = try container.decode(ReminderFrequency?.self, forKey: .reminderFrequency)
        symbol = try container.decode(String.self, forKey: .symbol)
        lastUpdated = Date()
        color = try container.decode(Color.self, forKey: .color)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encode(completedDates, forKey: .completedDates)
        try container.encode(startDate, forKey: .startDate)
        try container.encode(isHabitCompleted, forKey: .isHabitCompleted)
        try container.encode(completedDate, forKey: .completedDate)
        try container.encode(lastUpdated, forKey: .lastUpdated)
        try container.encode(reminderFrequency, forKey: .reminderFrequency)
        try container.encode(symbol, forKey: .symbol)
        try container.encode(color, forKey: .color)
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
        var date = from.startOfDay
        while isCompleted(on: date) {
            streak += 1
            date = Calendar.current.date(byAdding: .day, value: -1, to: date)!
        }
        return streak
    }
    
    func clearCompletedDates() {
       
        // remove completed dates before date below
        var datesToRemove = [DateComponents]()
        for dateComponent in completedDates {
            if let date = Calendar.current.date(from: dateComponent) {
                if date < startDate.startOfDay {
                    datesToRemove.append(dateComponent)
                }
            }
        }
        for dateComponent in datesToRemove {
            completedDates.remove(dateComponent)
        }
    }
    
    func calculateTotalCompleted() -> Int {
        return completedDates.count
    }
    
    func calculateLongestStreak() -> Int {
        var longestStreak = 0
        var date = Date().startOfDay
        while date >= startDate.startOfDay {
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
        while i < n && date >= startDate.startOfDay {
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
        lastUpdated = Date()
        completedDates.insert(Calendar.current.dateComponents([.year, .month, .day], from: noTimeDate))
    }
    
    func toggleCompletion() {
        isHabitCompleted.toggle()
        lastUpdated = Date()
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
    private static let lastReviewRequestDateKey = "lastReviewRequestDate"
    
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
    
    func saveLastReviewRequestDate(_ date: Date) {
        set(date, forKey: UserDefaults.lastReviewRequestDateKey)
    }
    
    func loadLastReviewRequestDate() -> Date? {
        return object(forKey: UserDefaults.lastReviewRequestDateKey) as? Date
    }
}
