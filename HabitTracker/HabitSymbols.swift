//
//  EventSymbols.swift
//  HabitTracker
//
//  Created by Saikat Kumar Dey on 27/07/23.
//

import Foundation

struct HabitSymbols {
    
    static var `default` : String = "lightbulb.fill"
    
    static var symbolDescriptions: [String: String] = [
            "lightbulb.fill":           "Creativity, inspiration, ideas",
            "cup.and.saucer.fill": "Coffee, tea, breakfast, drink",
            "figure.run" :             "Exercise, running, cardio",
            "figure.open.water.swim": "Swimming, water sports, water activities",
            "figure.hiking":          "Hiking, walking, trekking",
            "scalemass.fill":         "Weight loss, weight gain, diet",
            "paperplane.fill":       "Productivity, getting things done",
            "book.fill":                "Reading, self-improvement, professional learning",
            "briefcase.fill":           "Work, career goals, professional projects",
            "heart.fill":               "Health, fitness, and wellness activities",
            "house.fill":               "Home chores, home improvement, housekeeping",
            "dollarsign.circle.fill":   "Saving, investing, budgeting, financial goals",
            "leaf.arrow.circlepath":    "Sustainable living, recycling, being eco-friendly",
            "pencil":                   "Writing, journaling, planning",
            "person.2.fill":            "Social activities, spending time with family and friends",
            "moon.fill":                "Sleep, rest, relaxation, mindfulness",
            "laptopcomputer":           "Digital habits, coding, learning new tech",
            "laptopcomputer.and.iphone":"Digital habits, coding, learning new tech",
            "cart.fill":                "Shopping, personal errands",
            "figure.and.child.holdinghands": "Childcare, parenting",
            "gamecontroller.fill":      "Gaming, leisure time",
            "music.note":               "Music, playing an instrument, relaxation",
            "paintbrush.fill":          "Artistic pursuits, hobbies, DIY projects",
            "timer":                    "Time management, productivity, scheduling",
            "checkmark.circle.fill":    "Achievement, task completion",
            "trash.fill":               "Decluttering, cleaning, organizing",
            "pills.fill":               "Medication, vitamins, supplements",
            "cross.case.fill":          "Medical appointments, health checkups",
            "bicycle":                  "Cycling, biking, exercise",
            "car.fill":                 "Driving, car maintenance",
            "tram.fill":                "Public transportation, commuting",
            "airplane":                 "Travel, vacation, leisure",
            "sun.max.fill":             "Outdoor activities, gardening, yard work",
            "sunrise.fill":             "Morning routines, waking up early",
            "sunset.fill":              "Evening routines, going to bed early",
            "bed.double.fill":          "Bedtime routines, getting enough sleep",
            "hare.fill":                "Running, jogging, cardio",
            "tortoise.fill":            "Walking, hiking, leisurely exercise",
            "flame.fill":               "Cooking, baking, meal prep",
            "drop.fill":                "Hydration, drinking water",
            "bolt.fill":                "Electronics, device usage",
            "bolt.slash.fill":          "Electronics, device usage",
            "ant.fill":                 "Cleaning, housekeeping",
            "camera.fill":              "Photography, videography",
            "apps.iphone": "Communication, calling, messaging",
            "apps.iphone.badge.plus": "Communication, calling, messaging",
            "apps.iphone.landscape": "Communication, calling, messaging",
            "arrow.clockwise.icloud": "Weather awareness, outdoor activities",
            "arrow.clockwise.icloud.fill": "Weather awareness, outdoor activities",
            "arrow.counterclockwise.icloud": "Weather awareness, outdoor activities",
            "arrow.counterclockwise.icloud.fill": "Weather awareness, outdoor activities",
            "bolt.horizontal.icloud": "Weather awareness, outdoor activities",
            "4k.tv": "Tv, Device usage, technology habits",
            "4k.tv.fill": "Tv, Device usage, technology habits",
            "appletv": "Device usage, technology habits",
            "appletv.fill": "Device usage, technology habits",
            "apps.ipad": "Device usage, technology habits",
            "bolt.car": "Travel, commuting, transportation",
            "bolt.car.fill": "Travel, commuting, transportation",
            "bus": "Travel, commuting, transportation",
            "bus.doubledecker": "Travel, commuting, transportation",
            "bus.doubledecker.fill": "Travel, commuting, transportation",
            "arrow.up.and.person.rectangle.portrait": "Social interaction, family time",
            "externaldrive.badge.person.crop": "Social interaction, family time",
            "externaldrive.fill.badge.person.crop": "Social interaction, family time",
            "applewatch": "Time management, scheduling",
            "applewatch.radiowaves.left.and.right": "Time management, scheduling",
            "applewatch.slash": "Time management, scheduling",
            "applewatch.watchface": "Time management, scheduling",
            "arrow.clockwise": "Time management, scheduling",
        ]

    
    static var symbolNames: [String] {
           return Array(symbolDescriptions.keys)
       }

    
    static func randomName() -> String {
        if let random = symbolNames.randomElement() {
            return random
        } else {
            return ""
        }
    }
    
    static func randomNames(_ number: Int) -> [String] {
        var names: [String] = []
        for _ in 0..<number {
            names.append(randomName())
        }
        return names
    }

}
