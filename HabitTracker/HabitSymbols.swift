//
//  EventSymbols.swift
//  HabitTracker
//
//  Created by Saikat Kumar Dey on 27/07/23.
//

import Foundation

struct HabitSymbols {
    
    static var `default` : String = "lightbulb.fill"
    
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
        
    static var symbolNames: [String] = [
        "lightbulb.fill",           // Creativity, inspiration, ideas
        "book.fill",                // Reading, self-improvement, professional learning
        "briefcase.fill",           // Work, career goals, professional projects
        "heart.fill",               // Health, fitness, and wellness activities
        "house.fill",               // Home chores, home improvement, housekeeping
        "dollarsign.circle.fill",   // Saving, investing, budgeting, financial goals
        "leaf.arrow.circlepath",    // Sustainable living, recycling, being eco-friendly
        "pencil",                   // Writing, journaling, planning
        "person.2.fill",            // Social activities, spending time with family and friends
        "moon.fill",                // Sleep, rest, relaxation, mindfulness
        "laptopcomputer",           // Digital habits, coding, learning new tech
        "laptopcomputer.and.iphone",// Digital habits, coding, learning new tech
        "cart.fill",                // Shopping, personal errands
        "figure.and.child.holdinghands", // Childcare, parenting
        "gamecontroller.fill",      // Gaming, leisure time
        "music.note",               // Music, playing an instrument, relaxation
        "paintbrush.fill",          // Artistic pursuits, hobbies, DIY projects
        "timer",                    // Time management, productivity, scheduling
        "checkmark.circle.fill",    // Achievement, task completion
        "trash.fill",                // Decluttering, cleaning, organizing
        "pills.fill",               // Medication, vitamins, supplements
        "bicycle",                  // Cycling, biking, exercise
        "car.fill",                 // Driving, car maintenance
        "airplane",                 // Travel, vacation, leisure
        "sun.max.fill",             // Outdoor activities, gardening, yard work
        "sunrise.fill",             // Morning routines, waking up early
        "sunset.fill",              // Evening routines, going to bed early
        "bed.double.fill",          // Bedtime routines, getting enough sleep
        "hare.fill",                // Running, jogging, cardio
        "tortoise.fill",            // Walking, hiking, leisurely exercise
    ]

}
