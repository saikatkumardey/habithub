import SwiftUI

struct CurrentHabitsView: View{
    @EnvironmentObject var habitStore: HabitStore
    @State private var showingAddHabitSheet = false
    @State private var newHabitTitle = ""
    @State private var newHabitStartDate = Date()
    @State private var newHabitReminderTime = Date().startOfDay.addingTimeInterval(8*60*60)
    @State private var newHabitReminderEnabled : Bool = false
    
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
        let markAsDoneAction = UNNotificationAction(identifier: "MARK_AS_DONE", title: "Done ✅", options: [])
        let habitCategory = UNNotificationCategory(identifier: "HABIT_REMINDER", actions: [markAsDoneAction], intentIdentifiers: [], options: [])
        UNUserNotificationCenter.current().setNotificationCategories([habitCategory])
    }
    
    var body: some View {
        ZStack {

            Group{
                if uncompletedHabits.isEmpty {
                    
                    Spacer()
                    
                    Group{
                        Text("Please ")
                            .fontWeight(.ultraLight)
                        +
                        Text("add")
                            .fontWeight(.bold)
                            .foregroundColor(.green) +
                        Text(" a new habit to get started.")
                            .fontWeight(.ultraLight)
                    }
                    .font(.system(size: 40, weight: .bold, design: .rounded))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                    .padding(.top, 100)
                    
                    
                    Spacer()
                } else {
                    HabitListView(habits: uncompletedHabits)
                        .environmentObject(habitStore)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing:
                                    Button(action: {
                self.showingAddHabitSheet = true
            }) {
                Image(systemName: "plus")
                    .font(.system(size:20,weight: .light))
                    .foregroundColor(.white)
                    .padding(8)
                    .background(Circle().fill(Color.green))
                    .shadow(radius: 5)
            }
            )
            .fullScreenCover(isPresented: $showingAddHabitSheet) {
                AddHabit(newHabitTitle: $newHabitTitle,
                         newHabitStartDate: $newHabitStartDate,
                         newHabitReminderTime: $newHabitReminderTime,
                         newHabitReminderEnabled: $newHabitReminderEnabled
                ){
                    addHabit()
                }
            }
            .onAppear(perform: {
                requestNotificationPermission()
                registerNotificationCategory()
        })
        }
    }
    
    func addHabit() {
        let newHabit = Habit(title: newHabitTitle,
                             completedDates: [],
                             startDate: newHabitStartDate,
                             reminderTime: newHabitReminderTime,
                             isReminderEnabled: newHabitReminderEnabled
        )
        
        print("Adding new habit: \(newHabit.title)")
        habitStore.addHabit(newHabit)
        habitStore.listHabits()
        if newHabitReminderEnabled {
            habitStore.scheduleNotification(for: newHabit, at: newHabitReminderTime)
        }
        newHabitTitle = ""
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
                Spacer()
                Text("No habits completed yet.")
                    .font(.system(size: 40, weight: .ultraLight, design: .rounded))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                    .padding(.top, 100)
                Spacer()
            }
            else{
                HabitListView(habits: completedHabits)
                    .environmentObject(habitStore)
            }
        }
        //        .navigationBarTitle("Completed")
        //        .navigationBarTitleDisplayMode(.large)
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
                Label("Current", systemImage: "list.bullet")
            }
            NavigationView {
                CompletedHabitsView()
                    .environmentObject(habitStore)
            }
            .tabItem {
                Label("Completed", systemImage: "checkmark")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(HabitStore())
    }
}
