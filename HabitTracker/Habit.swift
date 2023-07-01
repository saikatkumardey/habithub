//
//  Habit.swift
//  HabitTracker
//
//  Created by Saikat Kumar Dey on 01/07/23.
//

import Foundation

class Habit: ObservableObject, Identifiable, Codable {
    @Published var title: String
    @Published var count: Int
    @Published var completedDates: [Date]
    @Published var maxStreak: Int = 0
    
    let id: UUID
    
    init(id: UUID = UUID(), title: String, count: Int, completedDates: [Date]) {
        self.id = id
        self.title = title
        self.count = count
        self.completedDates = completedDates
    }
    
    enum CodingKeys: String, CodingKey {
            case id, title, count, completedDates
        }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        count = try container.decode(Int.self, forKey: .count)
        completedDates = try container.decode([Date].self, forKey: .completedDates)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encode(count, forKey: .count)
        try container.encode(completedDates, forKey: .completedDates)
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
        if streak > maxStreak {
            maxStreak = streak
        }
        return streak
    }
    func lastNdayCells(n: Int) -> [Int] {
        var cells = [Int]()
        var date = Date()
        for _ in 0..<n {
            if isCompleted(on: date) {
                cells.append(1)
            } else {
                cells.append(0)
            }
            date = Calendar.current.date(byAdding: .day, value: -1, to: date)!
        }
        return cells.reversed()
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
