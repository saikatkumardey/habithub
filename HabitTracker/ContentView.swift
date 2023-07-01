import SwiftUI

class HabitStore: ObservableObject {
    @Published private(set) var habits: [Habit]

    init() {
        habits = UserDefaults.standard.loadHabits()
    }

    func addHabit(_ habit: Habit) {
        habits.append(habit)
        saveHabits()
    }
    
    func removeHabit(at offsets: IndexSet) {
        habits.remove(atOffsets: offsets)
        saveHabits()
    }

    func updateHabit(_ habit: Habit) {
        if let index = habits.firstIndex(where: { $0.id == habit.id }) {
            habits[index] = habit
            saveHabits()
        }
    }

    private func saveHabits() {
        UserDefaults.standard.saveHabits(habits)
    }
}

struct EmptyViewWithImageAndText: View {
    var image: String
    var text: String

    var body: some View {
        VStack {
            Image(image)
                .resizable()
                .scaledToFit()
                .frame(width: 300, height: 300)
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
            Text("Current streak: \(habit.calculateStreak()) days")
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
                            .foregroundColor(.red)
                    }
                }
            }
        }
    }
}

struct ContentView: View {
    @StateObject private var habitStore = HabitStore()
    @State private var showingAddHabitSheet = false
    @State private var newHabitTitle = ""

    var body: some View {
        NavigationView {
            Group{
                if habitStore.habits.isEmpty {
                    EmptyViewWithImageAndText(image: "cute_dog", text: "You don't have any habits yet.\nClick on + to add a new habit.")
                } else {
                    List {
                        ForEach(habitStore.habits, id: \.id) { habit in
                            NavigationLink(destination: HabitDetailView(habit: habit)) {
                                HabitRow(habit: habit)
                            
                            }
                        }
                        .onDelete(perform: removeHabit)
                    }
                }
            }
            .navigationBarTitle("Habits")
            .navigationBarItems(trailing:
                Button(action: {
                    self.showingAddHabitSheet = true
                }) {
                    Image(systemName: "plus")
                }
            )
            .sheet(isPresented: $showingAddHabitSheet) {
                AddHabitSheet(newHabitTitle: $newHabitTitle) {
                    self.addHabit()
                    self.showingAddHabitSheet = false
                }
            }
        }
    }

    func addHabit() {
        let newHabit = Habit(title: newHabitTitle, count: 0, completedDates: [])
        habitStore.addHabit(newHabit)
        newHabitTitle = ""
    }

    func removeHabit(at offsets: IndexSet) {
        habitStore.removeHabit(at: offsets)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
