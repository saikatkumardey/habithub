//
//  HabitRowView.swift
//  HabitTracker
//
//  Created by Saikat Kumar Dey on 09/07/23.
//

import SwiftUI

struct HabitRow: View {
    @Environment(\.scenePhase) var scenePhase
    @EnvironmentObject var habitStore: HabitStore
    @ObservedObject var habit: Habit
    @State private var isAddHabitSheetPresented = false
    @State private var lastNdays = [Int]()
    private let timer = Timer.publish(every: 60*60*3, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack(alignment: .topLeading){
            HStack(alignment: .center){
//                Image(systemName: habit.symbol)
//                    .resizable()
//                    .scaledToFit()
//                    .frame(width: 25, height: 25)
//                    .sfSymbolStyling()
//                    .foregroundStyle(habit.color)
//                    .padding(5)
                
                Text(habit.symbol)
                    .font(.system(size: 30))
                    .padding(5)
                
                VStack(alignment: .leading,spacing: 5) {
                    HStack(alignment: .top) {
                        Text(habit.title)
                            .font(.system(size: 18))
                            .fontDesign(.rounded)
                            .fontWeight(.light)
                            .foregroundColor(.primary)
                        Spacer()
                    }
                    
                    if !habit.isHabitCompleted{
                        Text(habit.startDate.formatted(date: .omitted, time: .shortened))
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .padding(.top,5)
                    }
                    
                    HStack{
                        ForEach(0..<lastNdays.count, id: \.self) { index in
                            let cell = lastNdays[index]
                            if index == lastNdays.count - 1 && cell == 0 {
                                Circle()
                                    .fill(Color.gray)
                                    .frame(width: 10, height: 10)
                            }
                            else if cell == 1 {
                                Circle()
                                    .fill(Color.green)
                                    .frame(width: 10, height: 10)
                            } else {
                                Circle()
                                    .fill(Color.red)
                                    .frame(width: 10, height: 10)
                            }
                        }
                    }
                    .padding(.vertical,10)
                    .onAppear(perform: {
                        lastNdays = habit.lastNdayCells(n: 7)
                        print("[OnAppear] Last N days: \(lastNdays)")
                    })
                    .onChange(of: scenePhase) { phase in
                        if phase == .active {
                            lastNdays = habit.lastNdayCells(n: 7)
                            print("Scene is active!, recomputing last N day cells.")
                        }
                    }
                    .onReceive(timer, perform: { _ in
                        print("Timer fired, recomputing last N day cells.")
                        lastNdays = habit.lastNdayCells(n: 7)
                    })
                }.padding(5)
                
            }
        }
    }
    
}


struct HabitRow_Previews: PreviewProvider {
    static var previews: some View {
        HabitRow(habit: Habit(title: "Drink water", completedDates: [], startDate: Date()))
            .padding(5)
    }
}
