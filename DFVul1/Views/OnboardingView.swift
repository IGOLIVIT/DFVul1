//
//  OnboardingView.swift
//  DFVul1
//
//  Created by IGOR on 04/09/2025.
//

import SwiftUI

struct OnboardingView: View {
    @StateObject private var viewModel = OnboardingViewModel()
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            // Background
            LinearGradient(
                colors: [
                    Color(hex: "#02102b"),
                    Color(hex: "#0a1a3b")
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            // Simple background stars
            GeometryReader { geometry in
                ForEach(0..<15, id: \.self) { index in
                    Circle()
                        .fill(Color.white.opacity(0.3))
                        .frame(width: 2, height: 2)
                        .position(
                            x: CGFloat.random(in: 20...(geometry.size.width - 20)),
                            y: CGFloat.random(in: 50...(geometry.size.height - 50))
                        )
                        .opacity(0.6)
                }
            }
            
            VStack(spacing: 0) {
                // Header with safe area
                VStack(spacing: 0) {
                    // Safe area spacer
                    Rectangle()
                        .fill(Color.clear)
                        .frame(height: 50)
                    
                    // Navigation bar
                    HStack {
                        if viewModel.currentStep.rawValue > 0 {
                            Button(action: viewModel.previousStep) {
                                Image(systemName: "chevron.left")
                                    .font(.title2)
                                    .foregroundColor(.white)
                            }
                        } else {
                            Rectangle()
                                .fill(Color.clear)
                                .frame(width: 44, height: 44)
                        }
                        
                        Spacer()
                        
                        Button("Skip") {
                            viewModel.completeOnboarding()
                            dismiss()
                        }
                        .foregroundColor(Color(hex: "#ffbe00"))
                        .font(.system(size: 16, weight: .medium))
                    }
                    .padding(.horizontal, 20)
                    .frame(height: 44)
                    
                    // Progress indicator
                    HStack(spacing: 8) {
                        ForEach(OnboardingViewModel.OnboardingStep.allCases.dropLast(), id: \.rawValue) { step in
                            Capsule()
                                .fill(step.rawValue <= viewModel.currentStep.rawValue ? 
                                      Color(hex: "#ffbe00") : Color.white.opacity(0.3))
                                .frame(width: step.rawValue <= viewModel.currentStep.rawValue ? 40 : 20, height: 4)
                        }
                    }
                    .padding(.top, 20)
                }
                
                // Main content area
                ScrollView {
                    VStack(spacing: 40) {
                        Spacer()
                            .frame(height: 40)
                        
                        switch viewModel.currentStep {
                        case .welcome:
                            WelcomeStepView()
                        case .gameIntro:
                            GameIntroStepView()
                        case .tutorial:
                            SimpleTutorialStepView()
                        case .features:
                            FeaturesStepView(isAnimating: viewModel.isAnimating)
                        case .completed:
                            CompletedStepView()
                        }
                        
                        Spacer()
                            .frame(height: 120)
                    }
                }
                
                // Bottom button area
                VStack(spacing: 0) {
                    Rectangle()
                        .fill(Color.clear)
                        .frame(height: 20)
                    
                    Button(action: {
                        if viewModel.currentStep == .completed {
                            viewModel.completeOnboarding()
                            dismiss()
                        } else {
                            viewModel.nextStep()
                        }
                    }) {
                        HStack(spacing: 8) {
                            Text(viewModel.currentStep.buttonText)
                                .font(.system(size: 18, weight: .semibold))
                            
                            if viewModel.currentStep != .completed {
                                Image(systemName: "arrow.right")
                                    .font(.system(size: 16, weight: .semibold))
                            }
                        }
                        .foregroundColor(Color(hex: "#02102b"))
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(Color(hex: "#ffbe00"))
                        .cornerRadius(28)
                    }
                    .padding(.horizontal, 20)
                    
                    Rectangle()
                        .fill(Color.clear)
                        .frame(height: 40)
                }
            }
        }
        .onAppear {
            viewModel.isAnimating = true
        }
    }
}

struct WelcomeStepView: View {
    var body: some View {
        VStack(spacing: 30) {
            // Animated logo/icon
            ZStack {
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [Color(hex: "#ffbe00").opacity(0.3), Color.clear],
                            center: .center,
                            startRadius: 0,
                            endRadius: 80
                        )
                    )
                    .frame(width: 160, height: 160)
                
                Image(systemName: "star.fill")
                    .font(.system(size: 60))
                    .foregroundColor(Color(hex: "#ffbe00"))
                    .rotationEffect(.degrees(0))
                    .animation(
                        Animation.easeInOut(duration: 3.0).repeatForever(autoreverses: false),
                        value: true
                    )
            }
            
            VStack(spacing: 16) {
                Text("Welcome to StarMatch")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                
                Text("Embark on a cosmic journey through the stars and unlock the secrets of the universe")
                    .font(.system(size: 18))
                    .foregroundColor(.white.opacity(0.8))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
            }
        }
    }
}

struct GameIntroStepView: View {
    var body: some View {
        VStack(spacing: 30) {
            // Game preview
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.black.opacity(0.3))
                    .frame(width: 280, height: 200)
                
                // Sample constellation
                ForEach(0..<7, id: \.self) { index in
                    Circle()
                        .fill(Color(hex: "#ffbe00"))
                        .frame(width: 12, height: 12)
                        .position(
                            x: 140 + CGFloat(index * 30 - 90),
                            y: 100 + CGFloat(sin(Double(index)) * 20)
                        )
                        .opacity(0.8)
                }
                
                // Connecting lines
                Path { path in
                    for index in 0..<6 {
                        let startX = 140 + CGFloat(index * 30 - 90)
                        let startY = 100 + CGFloat(sin(Double(index)) * 20)
                        let endX = 140 + CGFloat((index + 1) * 30 - 90)
                        let endY = 100 + CGFloat(sin(Double(index + 1)) * 20)
                        
                        if index == 0 {
                            path.move(to: CGPoint(x: startX, y: startY))
                        }
                        path.addLine(to: CGPoint(x: endX, y: endY))
                    }
                }
                .stroke(Color(hex: "#ffbe00").opacity(0.5), lineWidth: 2)
            }
            
            VStack(spacing: 16) {
                Text("Match the Constellations")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                
                Text("Connect stars of the same constellation to score points and learn about space")
                    .font(.system(size: 18))
                    .foregroundColor(.white.opacity(0.8))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
            }
        }
    }
}

struct SimpleTutorialStepView: View {
    var body: some View {
        VStack(spacing: 30) {
            VStack(spacing: 16) {
                Text("How to Play")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                
                Text("Learn the simple rules of StarMatch")
                    .font(.system(size: 18))
                    .foregroundColor(.white.opacity(0.8))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
            }
            
            // Static demonstration area
            VStack(spacing: 24) {
                // Step 1
                HStack(spacing: 16) {
                    ZStack {
                        Circle()
                            .fill(Color(hex: "#ffbe00"))
                            .frame(width: 40, height: 40)
                        
                        Text("1")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(Color(hex: "#02102b"))
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Find Matching Stars")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                        
                        Text("Look for stars of the same constellation")
                            .font(.system(size: 14))
                            .foregroundColor(.white.opacity(0.7))
                    }
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                
                // Step 2
                HStack(spacing: 16) {
                    ZStack {
                        Circle()
                            .fill(Color(hex: "#bd0e1b"))
                            .frame(width: 40, height: 40)
                        
                        Text("2")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.white)
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Connect 3 or More")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                        
                        Text("Tap 3+ stars to create a constellation")
                            .font(.system(size: 14))
                            .foregroundColor(.white.opacity(0.7))
                    }
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                
                // Step 3
                HStack(spacing: 16) {
                    ZStack {
                        Circle()
                            .fill(.white)
                            .frame(width: 40, height: 40)
                        
                        Text("3")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(Color(hex: "#02102b"))
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Score Points")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                        
                        Text("Earn points and unlock space facts")
                            .font(.system(size: 14))
                            .foregroundColor(.white.opacity(0.7))
                    }
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
            }
            
            // Visual example
            VStack(spacing: 12) {
                Text("Example Constellation")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white.opacity(0.8))
                
                HStack(spacing: 12) {
                    ForEach(0..<5, id: \.self) { index in
                        Circle()
                            .fill(Color(hex: "#ffbe00"))
                            .frame(width: 16, height: 16)
                    }
                }
                
                Text("Ursa Major (Big Dipper)")
                    .font(.system(size: 14))
                    .foregroundColor(Color(hex: "#ffbe00"))
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.black.opacity(0.3))
            )
            .padding(.horizontal, 20)
        }
    }
}

struct FeaturesStepView: View {
    let isAnimating: Bool
    
    var body: some View {
        VStack(spacing: 30) {
            VStack(spacing: 16) {
                Text("Discover Features")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.white)
                
                Text("Customize your star avatar, compete with friends, and discover educational tips")
                    .font(.system(size: 18))
                    .foregroundColor(.white.opacity(0.8))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
            }
            
            // Feature highlights
            VStack(spacing: 20) {
                FeatureRow(
                    icon: "person.crop.circle.fill",
                    title: "Star Avatars",
                    description: "Unlock unique constellation avatars",
                    color: Color(hex: "#bd0e1b"),
                    isAnimating: isAnimating
                )
                
                FeatureRow(
                    icon: "trophy.fill",
                    title: "Leaderboards",
                    description: "Compete with friends globally",
                    color: Color(hex: "#ffbe00"),
                    isAnimating: isAnimating
                )
                
                FeatureRow(
                    icon: "lightbulb.fill",
                    title: "Educational Tips",
                    description: "Learn about space and wellness",
                    color: Color.white,
                    isAnimating: isAnimating
                )
            }
        }
    }
}

struct FeatureRow: View {
    let icon: String
    let title: String
    let description: String
    let color: Color
    let isAnimating: Bool
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(color)
                .frame(width: 40, height: 40)
                .scaleEffect(isAnimating ? 1.1 : 1.0)
                .animation(.easeInOut(duration: 0.5), value: isAnimating)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
                
                Text(description)
                    .font(.system(size: 14))
                    .foregroundColor(.white.opacity(0.7))
            }
            
            Spacer()
        }
        .padding(.horizontal, 40)
    }
}

struct CompletedStepView: View {
    var body: some View {
        VStack(spacing: 30) {
            // Success animation
            ZStack {
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [Color(hex: "#ffbe00").opacity(0.3), Color.clear],
                            center: .center,
                            startRadius: 0,
                            endRadius: 100
                        )
                    )
                    .frame(width: 200, height: 200)
                
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 80))
                    .foregroundColor(Color(hex: "#ffbe00"))
            }
            
            VStack(spacing: 16) {
                Text("Ready to Explore!")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                
                Text("You're all set! Start your stellar adventure and reach for the stars")
                    .font(.system(size: 18))
                    .foregroundColor(.white.opacity(0.8))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
            }
        }
    }
}

#Preview {
    OnboardingView()
}
