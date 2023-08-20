//
//  HabitDetailView.swift
//  HabitTracker
//
//  Created by Saikat Kumar Dey on 19/08/23.
//
import SwiftUI

struct HabitDetailView: View {
    @EnvironmentObject var habit: Habit
    @EnvironmentObject var habitStore: HabitStore
    @Environment(\.scenePhase) var scenePhase
    @Environment(\.colorScheme) var colorScheme
    
    @State private var isEditing: Bool = false
    @State private var isPickingSymbol: Bool = false
    @State private var today: Date = Date().startOfDay.addingTimeInterval(86399)
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 15) {
                    HStack{
                        Image(systemName: "calendar")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 15, height: 15)
                            .sfSymbolStyling()
                            .foregroundStyle(.gray)
                        Text(habit.startDate, style: .date)
                            .font(.caption)
                            .fontDesign(.rounded)
                            .foregroundStyle(.secondary)
                        Spacer()
                        Image(systemName: "clock")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 15, height: 15)
                            .sfSymbolStyling()
                            .foregroundStyle(.gray)
                        Text(habit.startDate, style: .time)
                            .font(.caption)
                            .fontDesign(.rounded)
                            .foregroundStyle(.secondary)
                    }
                    
                    if habit.startDate.startOfDay > today {
                        Text("Habit will start on \(habit.startDate, style: .date)")
                            .font(.subheadline)
                        Button(action: {
                            habit.startDate = Date()
                            habitStore.updateHabit(habit)
                        }) {
                            Text("Start Now")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.green)
                                .cornerRadius(10)
                        }
                    } else{
                        
                        
                        MultiDatePicker("Select Dates", selection: $habit.completedDates, in: habit.startDate.startOfDay..<today)
                            .datePickerStyle(.graphical)
                            .onChange(of: habit.completedDates) { dates in
                                habitStore.updateHabit(habit)
                            }
                            .tint(.green)
                            .onAppear(){
                                print("onAppear")
                                today = Date().startOfDay.addingTimeInterval(86399)
                            }
                        
                        VStack(spacing:5) {
                            NumberCard(number: habit.calculateTotalCompleted(), text: "Total Completed Days", fillColor: .gray.opacity(0.1),iconColor: .green, icon: "checkmark.circle")
                            NumberCard(number: habit.calculateStreak(), text: "Current Streak", fillColor: .gray.opacity(0.1),iconColor: .pink, icon: "flame.fill")
                            NumberCard(number: habit.calculateLongestStreak(), text: "Maximum Streak", fillColor: .gray.opacity(0.1),iconColor: .orange, icon: "trophy.fill")
                        }
                    }
                }
                .padding()
            }
            .onChange(of: scenePhase) { phase in
                if phase == .active {
                    print("[HabitDetail]: Scene became active")
                    today = Date()
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    ZStack{
                        Circle()
                            .fill(Color(.systemGray6))
                            .frame(width: 40, height: 40)
                        
                        Image(systemName: habit.symbol)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 25, height: 25)
                            .sfSymbolStyling()
                            .foregroundStyle(colorScheme == .dark && habit.color == .black ? .primary : habit.color)
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing){
                    Button("Edit"){
                        isEditing = true
                    }
                }
            }
            .navigationTitle(habit.title)
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $isEditing) {
                AddHabit(isEditing: true){
                    habitStore.updateHabit(habit)
                }
                .environmentObject(habit)
            }
        }
    }
    
}

struct EditHabitView: View {
    @EnvironmentObject var habit: Habit
    
    var body: some View {
        // Your editing interface here
        Text("Editing interface here")
    }
}

// Date Formatter
let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .long
    return formatter
}()
