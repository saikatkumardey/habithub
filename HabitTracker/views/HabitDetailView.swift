//
//  HabitDetailView.swift
//  HabitTracker
//
//  Created by Saikat Kumar Dey on 19/08/23.
//
import SwiftUI
import StoreKit


struct HabitDetailView: View {
    @AppStorage("lastRequestDateEpoch") var lastRequestDateEpoch: Double = 0
    @AppStorage("daysToWait") var daysToWait: Int = 7
    
    @EnvironmentObject var habit: Habit
    @EnvironmentObject var habitStore: HabitStore
    @Environment(\.scenePhase) var scenePhase
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.requestReview) var requestReview
    
    @State private var isEditing: Bool = false
    @State private var isPickingSymbol: Bool = false
    @State private var today: Date = Date().startOfDay.addingTimeInterval(86399)
    
    func requestReviewIfAppropriate(userStreak: Int) {
        if userStreak > 0 &&  (userStreak % 7 == 0) {
            let daysSinceLastRequest = (Date().timeIntervalSince1970 - Double(lastRequestDateEpoch)) / 86400
            if daysSinceLastRequest >= Double(daysToWait) {
                requestReview()
                lastRequestDateEpoch = Date().timeIntervalSince1970
                daysToWait += 7
            }
        }
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 15) {
                        HStack{
                            Image(systemName: "calendar")
                                .resizable()
                                .frame(width: 15, height: 15)
                                .sfSymbolStyling()
                                .foregroundStyle(.gray)
                            Text(habit.startDate, style: .date)
                                .font(.caption)
                                .fontDesign(.monospaced)
                                .foregroundStyle(.secondary)
                        }
                        HStack{
                            Image(systemName: "alarm")
                                .resizable()
                                .frame(width: 15, height: 15)
                                .sfSymbolStyling()
                                .foregroundStyle(.gray)
                            Text(habit.startDate, style: .time)
                                .font(.caption)
                                .fontDesign(.monospaced)
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
                            .onChange(of: habit.completedDates) { dates in
                                print("onChange")
                                if habit.calculateStreak() > 0 {
                                    requestReviewIfAppropriate(userStreak: habit.calculateStreak())
                                }
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

// Date Formatter
let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .long
    return formatter
}()
