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
        case gameIntro = 1
        case tutorial = 2
        case features = 3
        case completed = 4
        
        var title: String {
            switch self {
            case .welcome:
                return "Welcome to StarMatch"
            case .gameIntro:
                return "Match the Constellations"
            case .tutorial:
                return "How to Play"
            case .features:
                return "Discover Features"
            case .completed:
                return "Ready to Explore!"
            }
        }
        
        var description: String {
            switch self {
            case .welcome:
                return "Embark on a cosmic journey through the stars and unlock the secrets of the universe"
            case .gameIntro:
                return "Connect stars of the same constellation to score points and learn about space"
            case .tutorial:
                return "Learn the simple rules of matching constellations"
            case .features:
                return "Customize your star avatar, compete with friends, and discover educational tips"
            case .completed:
                return "You're all set! Start your stellar adventure and reach for the stars"
            }
        }
        
        var buttonText: String {
            switch self {
            case .welcome, .gameIntro, .features:
                return "Continue"
            case .tutorial:
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
                if currentStep == .features {
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
