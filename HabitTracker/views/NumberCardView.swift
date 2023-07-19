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
    
    
    var body: some View {
        ZStack {
            
            RoundedRectangle(cornerRadius: 10)
                .fill(fillColor.opacity(0.8))
                .shadow(color: .gray, radius: 5)
                .foregroundColor(.clear)

            VStack{
               Text(text)
                    .font(.system(size: 16, weight: .light, design: .rounded))
                    .foregroundColor(.white)
                Text("\(number)")
                    .font(.system(size: 100, weight: .light, design: .rounded))
                    .foregroundColor(.white)
            }

        }
        .padding(.horizontal,5)
        .frame(width:180.0,height:180.0)

    }
}

// Preview
struct NumberCard_Previews: PreviewProvider {
    static var previews: some View {
            VStack{
                HStack{
                    NumberCard(number: 25, text: "Total Days", fillColor: .blue)
                    NumberCard(number: 15, text: "Total completed")
                }
                HStack{
                    NumberCard(number: 15, text: "Total Days")
                    NumberCard(number: 25, text: "Total completed")
                }
        }
    }
}

