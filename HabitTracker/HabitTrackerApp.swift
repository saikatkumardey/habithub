//
//  HabitTrackerApp.swift
//  HabitTracker
//
//  Created by Saikat Kumar Dey on 01/07/23.
//

import SwiftUI

@main
struct HabitTrackerApp: App {
    
    @StateObject private var habitStore = HabitStore()
    @StateObject private var notificationDelegate = NotificationDelegate()
  
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(habitStore)
                .font(.system(.body, design: .rounded))
                .onAppear(perform: {
                    UNUserNotificationCenter.current().delegate = notificationDelegate
                    notificationDelegate.habitStore = habitStore
                })
//                .foregroundStyle(.secondary)
//                .tint(.teal)
//                .background(.secondary)
        }
    }
}
