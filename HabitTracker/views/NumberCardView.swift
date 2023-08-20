//
//  NumberCard.swift
//  HabitTracker
//
//  Created by Saikat Kumar Dey on 16/07/23.
//

import SwiftUI

struct NumberCard: View {
    let number: Int
    let text: String
    var fillColor: Color = .green
    var iconColor: Color = .secondary
    let icon: String
    
    var body: some View {
        ZStack {
            
            RoundedRectangle(cornerRadius: 10)
                .fill(fillColor)
                .shadow(color:.secondary.opacity(0.7), radius: 10)

            VStack(alignment: .center){
                HStack(alignment: .lastTextBaseline){
                    Image(systemName: icon)
                        .sfSymbolStyling()
                        .foregroundColor(iconColor)
                        .font(.system(size: 30))
                        .fontWeight(.bold)
                    Text(text)
                        .font(.title2)
                        .fontDesign(.rounded)
                        .foregroundColor(.primary)
                }
                .padding(.top,10)
                Text("\(number)")
                    .font(.system(size: 100, weight: .bold, design: .rounded))
                    .foregroundColor(.primary)
                    .shadow(color:.white.opacity(0.7), radius: 3)
            }
        }
    }
}

// Preview
struct NumberCard_Previews: PreviewProvider {
    static var previews: some View {
            VStack{
                HStack{
                    NumberCard(number: 25, text: "Total Days", fillColor: .blue, icon: "checkmark.circle")
                    NumberCard(number: 15, text: "Total completed", fillColor: .red, icon: "xmark.circle.fill")
                }
                HStack{
                    NumberCard(number: 15, text: "Total Days", fillColor: .blue, icon: "checkmark.circle")
                    NumberCard(number: 25, text: "Total completed", fillColor: .red, icon: "xmark.circle.fill")
                }
        }
    }
}

