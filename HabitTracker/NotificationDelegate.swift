//
//  NotificationDelegate.swift
//  HabitTracker
//
//  Created by Saikat Kumar Dey on 04/07/23.
//

import SwiftUI
import UserNotifications

class NotificationDelegate: NSObject, UNUserNotificationCenterDelegate, ObservableObject {

    var habitStore: HabitStore?

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound])
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        if response.actionIdentifier == "MARK_AS_DONE" {
            if let habitIdString = response.notification.request.content.userInfo["habitId"] as? String,
               let habitId = UUID(uuidString: habitIdString),
               let habitStore = habitStore,
               let habit = habitStore.getHabit(by: habitId) {
                habitStore.markDayAsCompleted(habit, date: Date())
            } else {
                print("Error: Unable to mark habit as completed")
                print("habitIdString: \(String(describing: response.notification.request.content.userInfo["habitId"] as? String))")
            }
        }
        
        completionHandler()
    }
}
