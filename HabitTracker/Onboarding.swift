//
//  Onboarding.swift
//  HabitTracker
//
//  Created by Saikat Kumar Dey on 29/07/23.
//
import SwiftUI

struct OnboardingView: View {
    @Binding var hasCompletedOnboarding: Bool
    @State private var currentPage = 0
    
    var body: some View {
        VStack {
            TabView(selection: $currentPage) {
                WelcomeView()
                    .tag(0)
                FeatureView(
                    feature: "Add",
                    description: "Easily add habits you want to build, set reminders, and track your progress.",
                    imageName: "OnboardingAdd"
                )
                .tag(1)
                FeatureView(
                    feature: "Track",
                    description: "Keep track of your habits and see your progress over time.",
                    imageName: "OnboardingTrack"
                )
                .tag(2)
                FeatureView(
                    feature: "You're all set!",
                    description: "Start building and tracking habits now.",
                    imageName: "OnboardingFinal"
                )
                .tag(3)
            }
            .tabViewStyle(PageTabViewStyle())
            .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .interactive))
            
            HStack{
                Button(action: {
                    if currentPage < 3 {
                        withAnimation {
                            currentPage += 1
                        }
                    } else {
                        hasCompletedOnboarding = true
                    }
                }) {
                    Text(currentPage == 3 ? "Get Started" : "Next")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.horizontal,10)
                        .padding(.vertical,5)
                }
                .buttonStyle(.bordered)
                
                if currentPage > 0 && currentPage < 3 {
                    Button(action: {
                        hasCompletedOnboarding = true
                    }) {
                        Text("Skip")
                            .font(.title)
                            .foregroundColor(.secondary)
                            .underline()
                            .fontWeight(.light)
                            .padding(.horizontal,10)
                            .padding(.vertical,5)
                    }
                }
            }
        }
    }
}

struct WelcomeView: View {
    var body: some View {
        
        // Welcome message
        VStack {
            Image("WelcomeIcon")
                .resizable()
                .frame(width: 200, height: 200)
                .padding(.bottom, -20)
            
            Text("Welcome to HabitHub")
                .font(.largeTitle)
                .fontWeight(.bold)
                .fontDesign(.rounded)
                .foregroundColor(.primary)
            Text("Small habits, big results.")
                .font(.subheadline)
                .fontWeight(.light)
                .fontDesign(.rounded)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
    }
}

struct FeatureView: View {
    var feature: String
    var description: String
    var imageName: String
    
    var body: some View {
        VStack {
            Text(feature)
                .font(.title)
                .padding(.bottom,5)
            
            Image(imageName)
                .resizable()
                .scaledToFit()
                .shadow(color: .gray,radius:5)
                .clipShape(RoundedRectangle(cornerRadius: 20))
            
            Spacer()
            
            //            Text(description)
            //                .font(.body)
            //                .multilineTextAlignment(.center)
            //                .padding(.bottom,30)
            //            Spacer()
        }
    }
}

struct GetStartedView: View {
    var body: some View {
        VStack {
            Text("You're all set!")
                .font(.largeTitle)
            Text("Start exploring the app now.")
                .font(.body)
        }
    }
}

// preview
struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView(hasCompletedOnboarding: .constant(false))
            .preferredColorScheme(.light)
            .background(.green.opacity(0.1))
    }
}

