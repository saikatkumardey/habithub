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
                .shadow(color:.primary.opacity(0.3), radius: 20)

            VStack(alignment: .center){
                HStack{
                    Image(systemName: icon)
                        .foregroundColor(iconColor)
                        .font(.system(size: 40))
                    Text(text)
                        .font(.title2)
                        .fontWeight(.thin)
                        .fontDesign(.serif)
                        .foregroundColor(.secondary)
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

