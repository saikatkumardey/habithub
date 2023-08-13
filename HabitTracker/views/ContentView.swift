import SwiftUI
import StoreKit


struct CurrentHabitsView: View{
    @EnvironmentObject var habitStore: HabitStore
    @State private var today = Date()
    private let timer = Timer.publish(every: 60*60*3, on: .main, in: .common).autoconnect()
    
    
    private var uncompletedHabits: [Habit] {
        habitStore.habits.filter { !$0.isHabitCompleted }
    }
    
    func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted {
                print("Notification permission granted.")
            } else if let error = error {
                print("Error requesting notification permissions: \(error.localizedDescription)")
            } else {
                print("Notification permission not granted.")
            }
        }
    }
    
    func registerNotificationCategory() {
//        let markAsDoneAction = UNNotificationAction(identifier: "MARK_AS_DONE", title: "Done ✅", options: [])
        let habitCategory = UNNotificationCategory(identifier: "HABIT_REMINDER", actions: [], intentIdentifiers: [], options: [])
        UNUserNotificationCenter.current().setNotificationCategories([habitCategory])
    }
    
    var body: some View {
        
        HabitListView(habits: uncompletedHabits, isCompleted: false)
            .environmentObject(habitStore)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Text("It's \(today.formatted(date: .complete, time: .omitted)).")
                    .font(.system(size: 20, design: .rounded))
                    .foregroundColor(.gray)
            )
            .onAppear(perform: {
                print("CurrentHabitsView appeared.")
                
                UNUserNotificationCenter.current().getNotificationSettings { settings in
                    if settings.authorizationStatus == .authorized {
                        print("Notification permission already granted.")
                    } else {
                        requestNotificationPermission()
                        registerNotificationCategory()
                    }
                }
                
                today = Date()
            })
            .onReceive(timer, perform: { _ in
                today = Date()
            })
    }
}

struct CompletedHabitsView: View {
    @EnvironmentObject var habitStore: HabitStore
    
    private var completedHabits: [Habit] {
        habitStore.habits.filter { $0.isHabitCompleted }
    }
    
    var body: some View {
        
        Group{
            if completedHabits.isEmpty {
//                Spacer()
                Text("No habits completed yet.")
                    .font(.system(size: 40, weight: .ultraLight, design: .rounded))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                    .padding(.top, 100)
//                Spacer()
            }
            else{
                HabitListView(habits: completedHabits, isCompleted: true)
                    .environmentObject(habitStore)
            }
        }
        .navigationBarTitle("Completed Habits")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
    }
}

struct ContentView: View {

    @EnvironmentObject private var habitStore: HabitStore

    var body: some View {
        TabView {
            NavigationView {
                CurrentHabitsView()
                    .environmentObject(habitStore)
            }
            .tabItem {
                Label("Current", systemImage: "list.bullet.circle")
            }
            NavigationView {
                CompletedHabitsView()
                    .environmentObject(habitStore)
            }
            .tabItem {
                Label("Completed", systemImage: "checkmark.circle")
            }
        }
        .background(.clear)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(HabitStore())
    }
}
