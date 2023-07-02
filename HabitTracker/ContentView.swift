import SwiftUI

class HabitStore: ObservableObject {
    @Published private(set) var habits: [Habit]
    @Published var habitsChanged = false

    init() {
        habits = UserDefaults.standard.loadHabits()
    }

    func addHabit(_ habit: Habit) {
        habits.append(habit)
    }
    
    func markHabitAsCompleted(_ habit: Habit) {
        if let index = habits.firstIndex(where: { $0.id == habit.id }) {
            habits[index].isHabitCompleted = true
        }
    }
    
    func removeHabit(at offsets: IndexSet) {
        habits.remove(atOffsets: offsets)
    }

    func updateHabit(_ habit: Habit) {
        if let index = habits.firstIndex(where: { $0.id == habit.id }) {
            habits[index] = habit
        }
    }

    private func saveHabits() {
        UserDefaults.standard.saveHabits(habits)
    }
    
    func deleteHabit(_ habit: Habit) {
            if let index = habits.firstIndex(where: { $0.id == habit.id }) {
                habits.remove(at: index)
            }
    }
}

struct EmptyViewWithImageAndText: View {
    var image: String
    var text: String

    var body: some View {
        VStack{
            Image(image)
                .resizable()
                .scaledToFit()
                .frame(width: 300, height: 400)
            Text(text)
                .font(.title2)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
    }
}

struct HabitRow: View {
    @ObservedObject var habit: Habit

    var body: some View {
        VStack(alignment: .leading) {
            Text(habit.title)
                .font(.headline)
            
            if !habit.isHabitCompleted{
                Text("Current streak: \(habit.calculateStreak()) days")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Text("Longest streak: \(habit.maxStreak) days")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            // last 7 days
            HStack {
                ForEach(habit.lastNdayCells(n: 7), id: \.self) { cell in
                    if cell == 1 {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                    } else {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.pink)
                    }
                }
            }
        }
        }
    }
}

struct HabitListView: View {
    @EnvironmentObject var habitStore: HabitStore
    var habits: [Habit]

    var body: some View {
        List {
            ForEach(habits, id: \.id) { habit in
                    NavigationLink(destination: HabitDetailView(habit: habit).environmentObject(habitStore)) {
                        HabitRow(habit: habit)
                    }
            }.onDelete(perform: deleteHabit)
        }
    }
    
    private func deleteHabit(at offsets: IndexSet) {
            offsets.forEach { index in
                let habit = habits[index]
                habitStore.deleteHabit(habit)
            }
    }
}


struct CurrentHabitsView: View{
    @EnvironmentObject var habitStore: HabitStore
    @State private var showingAddHabitSheet = false
    @State private var newHabitTitle = ""
    @State private var newHabitStartDate = Date()
    
    private var uncompletedHabits: [Habit] {
        habitStore.habits.filter { !$0.isHabitCompleted }
    }

    var body: some View {
            Group{
                if uncompletedHabits.isEmpty {
                    EmptyViewWithImageAndText(image: "cute_dog", text: "Please click on + to add a new habit.")
                    Spacer()
                } else {
                    HabitListView(habits: uncompletedHabits)
                        .environmentObject(habitStore)
                }
            }
            .navigationBarTitle("Track My Habits")
            .navigationBarItems(trailing:
                Button(action: {
                    self.showingAddHabitSheet = true
            }) {
                    Image(systemName: "plus")
                    .font(.system(size:16,weight: .bold))
                    .foregroundColor(.white)
                    .padding(5)
                    .background(Circle().fill(Color.blue))
                    .shadow(radius: 3)
                }
            )
            .sheet(isPresented: $showingAddHabitSheet) {
                AddHabitSheet(newHabitTitle: $newHabitTitle, newHabitStartDate: $newHabitStartDate) {
                    self.addHabit()
                    self.showingAddHabitSheet = false
                }
            }
            .onChange(of: habitStore.habitsChanged) { _ in }
        }

    func addHabit() {
        let newHabit = Habit(title: newHabitTitle, completedDates: [], startDate: newHabitStartDate)
        habitStore.addHabit(newHabit)
        newHabitTitle = ""
    }

    func removeHabit(at offsets: IndexSet) {
        habitStore.removeHabit(at: offsets)
    }
}

struct CompletedHabitsView: View {
    @EnvironmentObject var habitStore: HabitStore
    
    private var completedHabits: [Habit] {
        habitStore.habits.filter { $0.isHabitCompleted }
    }

    var body: some View {
        
        if completedHabits.isEmpty {
            EmptyViewWithImageAndText(image: "cute_dog", text: "You don't have any completed habits yet.😊")
        }
        else{
            HabitListView(habits: completedHabits)
                .environmentObject(habitStore)
                .onChange(of: habitStore.habitsChanged) { _ in }
                .navigationBarTitle("Track My Habits")
        }
    }
}



struct ContentView: View {
    @StateObject private var habitStore = HabitStore()
    

    var body: some View {
        TabView {
            NavigationView {
                CurrentHabitsView()
                    .environmentObject(habitStore)
            }
            .tabItem {
                Image(systemName: "list.bullet")
                Text("Current Habits")
            }

            NavigationView {
                CompletedHabitsView()
                    .environmentObject(habitStore)
            }
            .tabItem {
                Image(systemName: "checkmark")
                Text("Completed Habits")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
