//
//  OnboardingViewModel.swift
//  DFVul1
//
//  Created by IGOR on 04/09/2025.
//

import Foundation
import SwiftUI

class OnboardingViewModel: ObservableObject {
    @Published var currentStep: OnboardingStep = .welcome
    @Published var isAnimating = false
    
    @AppStorage("hasCompletedOnboarding") var hasCompletedOnboarding = false
    @AppStorage("onboardingProgress") private var onboardingProgressValue = 0
    
    enum OnboardingStep: Int, CaseIterable {
        case welcome = 0
        case gameRules = 1
        case howToPlay = 2
        case scoring = 3
        case completed = 4
        
        var title: String {
            switch self {
            case .welcome:
                return "Welcome to StarMatch"
            case .gameRules:
                return "Game Rules"
            case .howToPlay:
                return "How to Play"
            case .scoring:
                return "Scoring System"
            case .completed:
                return "Ready to Play!"
            }
        }
        
        var description: String {
            switch self {
            case .welcome:
                return "A constellation matching puzzle game where you identify and connect stars to form famous constellations from astronomy."
            case .gameRules:
                return "🎯 OBJECTIVE: Find and select stars that belong to the same constellation.\n\n⭐ You need to select at least 3 stars of the target constellation to score points.\n\n⏰ Complete as many constellations as possible before time runs out."
            case .howToPlay:
                return "1️⃣ TAP stars on the screen to select them\n\n2️⃣ Selected stars will glow and show a selection ring\n\n3️⃣ When you select 3+ stars of the same constellation, they automatically match\n\n4️⃣ Matched stars turn green with checkmarks\n\n5️⃣ Continue finding more constellations!"
            case .scoring:
                return "🏆 POINTS:\n• 3 stars = 100 points\n• 4 stars = 200 points\n• 5+ stars = 300+ points\n\n🔥 COMBO BONUS:\n• Match constellations quickly for combo multipliers\n\n📚 LEARNING:\n• Each constellation teaches you astronomy facts and wellness tips!"
            case .completed:
                return "You now know how to play StarMatch! Use the Constellation Guide to study star patterns, then test your knowledge in the game. Good luck, astronomer!"
            }
        }
        
        var buttonText: String {
            switch self {
            case .welcome, .gameRules, .howToPlay, .scoring:
                return "Continue"
            case .completed:
                return "Start Playing"
            }
        }
    }
    
    
    init() {
        // Always start from beginning for tutorial
        resetToBeginning()
    }
    
    func nextStep() {
        withAnimation(.easeInOut(duration: 0.3)) {
            if currentStep.rawValue < OnboardingStep.allCases.count - 1 {
                currentStep = OnboardingStep(rawValue: currentStep.rawValue + 1) ?? .welcome
                saveProgress()
                
                // Handle specific step setup
                if currentStep == .scoring {
                    startFeatureAnimation()
                }
            } else {
                // Move to completed step
                currentStep = .completed
            }
        }
    }
    
    func previousStep() {
        withAnimation(.easeInOut(duration: 0.5)) {
            if currentStep.rawValue > 0 {
                currentStep = OnboardingStep(rawValue: currentStep.rawValue - 1) ?? .welcome
                saveProgress()
            }
        }
    }
    
    func skipOnboarding() {
        completeOnboarding()
    }
    
    func completeOnboarding() {
        hasCompletedOnboarding = true
    }
    
    
    private func startFeatureAnimation() {
        withAnimation(.easeInOut(duration: 2.0)) {
            isAnimating = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            withAnimation(.easeInOut(duration: 0.5)) {
                self.isAnimating = false
            }
        }
    }
    
    private func saveProgress() {
        onboardingProgressValue = currentStep.rawValue
    }
    
    private func loadProgress() {
        if !hasCompletedOnboarding {
            currentStep = OnboardingStep(rawValue: onboardingProgressValue) ?? .welcome
        }
    }
    
    func resetOnboarding() {
        hasCompletedOnboarding = false
        onboardingProgressValue = 0
        currentStep = .welcome
        isAnimating = false
    }
    
    private func resetToBeginning() {
        currentStep = .welcome
        isAnimating = false
        onboardingProgressValue = 0
    }
}

// MARK: - Animation Helpers
extension OnboardingViewModel {
    func getWelcomeAnimation() -> Animation {
        return Animation.easeInOut(duration: 2.0).repeatForever(autoreverses: true)
    }
}
