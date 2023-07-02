//
//  Habit.swift
//  HabitTracker
//
//  Created by Saikat Kumar Dey on 01/07/23.
//

import Foundation

class Habit: ObservableObject, Identifiable, Codable {
    @Published var title: String
    @Published var completedDates: [Date]
    @Published var maxStreak: Int = 0
    @Published var startDate: Date = Date()
    @Published var isHabitCompleted: Bool = false
    
    let id: UUID
    
    init(id: UUID = UUID(), title: String, completedDates: [Date], startDate: Date = Date(), isCompleted: Bool = false) {
        self.id = id
        self.title = title
        self.completedDates = completedDates
        self.startDate = startDate
        self.isHabitCompleted = isCompleted
    }
    
    enum CodingKeys: String, CodingKey {
            case id, title, count, completedDates, startDate, isHabitCompleted
        
        }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        completedDates = try container.decode([Date].self, forKey: .completedDates)
        startDate = try container.decode(Date.self, forKey: .startDate)
        isHabitCompleted = try container.decode(Bool.self, forKey: .isHabitCompleted)
    
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encode(completedDates, forKey: .completedDates)
        try container.encode(startDate, forKey: .startDate)
        try container.encode(isHabitCompleted, forKey: .isHabitCompleted)
    }

    func toggleCompletion(for date: Date) {
        let noTimeDate = date.startOfDay
        if let index = completedDates.firstIndex(where: { $0 == noTimeDate }) {
            completedDates.remove(at: index)
        } else {
            completedDates.append(noTimeDate)
        }
    }
    
    func isCompleted(on date: Date) -> Bool {
        let noTimeDate = date.startOfDay
        return completedDates.contains(noTimeDate)
    }
    
    func calculateStreak() -> Int {
        var streak = 0
        var date = Date()
        while isCompleted(on: date) {
            streak += 1
            date = Calendar.current.date(byAdding: .day, value: -1, to: date)!
        }
        return streak
    }
    
    func calculateLongestStreak() -> Int {
        var longestStreak = 0
        var date = Date()
        while date >= startDate {
            var streak = 0
            while isCompleted(on: date) {
                streak += 1
                date = Calendar.current.date(byAdding: .day, value: -1, to: date)!
            }
            longestStreak = max(streak, longestStreak)
            date = Calendar.current.date(byAdding: .day, value: -1, to: date)!
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
    
    func toggleCompletion() {
        isHabitCompleted.toggle()
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
