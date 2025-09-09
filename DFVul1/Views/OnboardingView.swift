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
                        case .gameRules:
                            GameRulesStepView()
                        case .howToPlay:
                            HowToPlayStepView()
                        case .scoring:
                            ScoringStepView(isAnimating: viewModel.isAnimating)
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
            // Logo animation
            ZStack {
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                Color(hex: "#ffbe00").opacity(0.3),
                                Color.clear
                            ],
                            center: .center,
                            startRadius: 0,
                            endRadius: 100
                        )
                    )
                    .frame(width: 200, height: 200)
                
                Image(systemName: "star.fill")
                    .font(.system(size: 80))
                    .foregroundColor(Color(hex: "#ffbe00"))
            }
            .frame(height: 200)
            
            VStack(spacing: 16) {
                Text("Welcome to StarMatch")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                
                Text("A constellation matching puzzle game where you identify and connect stars to form famous constellations from astronomy.")
                    .font(.system(size: 18))
                    .foregroundColor(.white.opacity(0.8))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
            }
        }
    }
}

struct GameRulesStepView: View {
    var body: some View {
        VStack(spacing: 30) {
            // Game rules icon
            ZStack {
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                Color(hex: "#bd0e1b").opacity(0.3),
                                Color.clear
                            ],
                            center: .center,
                            startRadius: 0,
                            endRadius: 80
                        )
                    )
                    .frame(width: 160, height: 160)
                
                Image(systemName: "target")
                    .font(.system(size: 60, weight: .medium))
                    .foregroundColor(Color(hex: "#bd0e1b"))
            }
            .frame(height: 160)
            
            VStack(spacing: 16) {
                Text("Game Rules")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                
                Text("🎯 OBJECTIVE: Find and select stars that belong to the same constellation.\n\n⭐ You need to select at least 3 stars of the target constellation to score points.\n\n⏰ Complete as many constellations as possible before time runs out.")
                    .font(.system(size: 16))
                    .foregroundColor(.white.opacity(0.9))
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                    .padding(.horizontal, 20)
            }
        }
    }
}

struct HowToPlayStepView: View {
    var body: some View {
        VStack(spacing: 30) {
            // How to play icon
            ZStack {
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                Color(hex: "#ffbe00").opacity(0.3),
                                Color.clear
                            ],
                            center: .center,
                            startRadius: 0,
                            endRadius: 80
                        )
                    )
                    .frame(width: 160, height: 160)
                
                Image(systemName: "hand.tap.fill")
                    .font(.system(size: 60, weight: .medium))
                    .foregroundColor(Color(hex: "#ffbe00"))
            }
            .frame(height: 160)
            
            VStack(spacing: 16) {
                Text("How to Play")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                
                Text("1️⃣ TAP stars on the screen to select them\n\n2️⃣ Selected stars will glow and show a selection ring\n\n3️⃣ When you select 3+ stars of the same constellation, they automatically match\n\n4️⃣ Matched stars turn green with checkmarks\n\n5️⃣ Continue finding more constellations!")
                    .font(.system(size: 16))
                    .foregroundColor(.white.opacity(0.9))
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                    .padding(.horizontal, 20)
            }
        }
    }
}

struct ScoringStepView: View {
    let isAnimating: Bool
    
    var body: some View {
        VStack(spacing: 30) {
            // Scoring icon
            ZStack {
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                Color.white.opacity(0.3),
                                Color.clear
                            ],
                            center: .center,
                            startRadius: 0,
                            endRadius: 80
                        )
                    )
                    .frame(width: 160, height: 160)
                
                Image(systemName: "trophy.fill")
                    .font(.system(size: 60, weight: .medium))
                    .foregroundColor(.white)
            }
            .frame(height: 160)
            
            VStack(spacing: 16) {
                Text("Scoring System")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                
                Text("🏆 POINTS:\n• 3 stars = 100 points\n• 4 stars = 200 points\n• 5+ stars = 300+ points\n\n🔥 COMBO BONUS:\n• Match constellations quickly for combo multipliers\n\n📚 LEARNING:\n• Each constellation teaches you astronomy facts and wellness tips!")
                    .font(.system(size: 16))
                    .foregroundColor(.white.opacity(0.9))
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                    .padding(.horizontal, 20)
            }
        }
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
            .frame(height: 200)
            
            VStack(spacing: 16) {
                Text("Ready to Play!")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                
                Text("You now know how to play StarMatch! Use the Constellation Guide to study star patterns, then test your knowledge in the game. Good luck, astronomer!")
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
