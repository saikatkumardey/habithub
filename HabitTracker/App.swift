//
//  HabitTrackerApp.swift
//  HabitTracker
//
//  Created by Saikat Kumar Dey on 01/07/23.
//

import SwiftUI

@main
struct HabitTrackerApp: App {
    @AppStorage("hasCompletedOnboarding") var hasCompletedOnboarding: Bool = false
    @StateObject private var habitStore = HabitStore()
    @StateObject private var notificationDelegate = NotificationDelegate()
    
    var body: some Scene {
        WindowGroup {
            if !hasCompletedOnboarding {
                OnboardingView(hasCompletedOnboarding: $hasCompletedOnboarding)
            } else {
                ContentView()
                    .environmentObject(habitStore)
                    .font(.system(.body, design: .rounded))
                    .onAppear(perform: {
                        UNUserNotificationCenter.current().delegate = notificationDelegate
                        notificationDelegate.habitStore = habitStore
                    })
            }
        }
    }
}
