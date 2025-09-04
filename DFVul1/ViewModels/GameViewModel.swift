//
//  GameViewModel.swift
//  DFVul1
//
//  Created by IGOR on 04/09/2025.
//

import Foundation
import SwiftUI
import Combine

class GameViewModel: ObservableObject {
    @Published var stars: [Star] = []
    @Published var currentConstellation: Star.ConstellationType = .ursa
    @Published var gameState: GameState = .menu
    @Published var score: Int = 0
    @Published var timeRemaining: TimeInterval = 90.0
    @Published var selectedStars: [Star] = []
    @Published var matchedStars: Set<UUID> = []
    @Published var showingEducationalTip = false
    @Published var currentTip = ""
    @Published var level = 1
    @Published var combo = 0
    @Published var showingCombo = false
    @Published var particles: [StarParticle] = []
    
    private var gameTimer: Timer?
    private var comboTimer: Timer?
    private let userService = UserService.shared
    private var cancellables = Set<AnyCancellable>()
    private let hapticFeedback = UIImpactFeedbackGenerator(style: .medium)
    
    enum GameState {
        case menu
        case playing
        case paused
        case gameOver
        case completed
        case tutorial
    }
    
    struct StarParticle: Identifiable {
        let id = UUID()
        var position: CGPoint
        var velocity: CGVector
        var life: Double = 1.0
        let color: Color
    }
    
    init() {
        setupGame()
    }
    
    func startGame() {
        gameState = .playing
        score = 0
        combo = 0
        level = 1
        timeRemaining = userService.difficulty.timeLimit
        matchedStars.removeAll()
        selectedStars.removeAll()
        particles.removeAll()
        
        generateStars()
        startTimer()
        
        if userService.hapticEnabled {
            hapticFeedback.impactOccurred()
        }
    }
    
    func pauseGame() {
        gameState = .paused
        gameTimer?.invalidate()
    }
    
    func resumeGame() {
        gameState = .playing
        startTimer()
    }
    
    func endGame() {
        gameState = .gameOver
        gameTimer?.invalidate()
        comboTimer?.invalidate()
        
        // Update user progress
        userService.updateScore(score)
        userService.addStarsMatched(matchedStars.count)
        
        if matchedStars.count == stars.count {
            userService.recordPerfectGame()
            userService.completeConstellation(currentConstellation)
        } else {
            userService.resetStreak()
        }
        
        userService.recordTime(userService.difficulty.timeLimit - timeRemaining)
        userService.levelUp()
    }
    
    func selectStar(_ star: Star) {
        guard gameState == .playing else { return }
        
        if let index = stars.firstIndex(where: { $0.id == star.id }) {
            stars[index].isSelected.toggle()
            
            if stars[index].isSelected {
                selectedStars.append(stars[index])
                if userService.soundEnabled {
                    // Play selection sound
                }
            } else {
                selectedStars.removeAll { $0.id == star.id }
            }
            
            checkForMatch()
        }
    }
    
    func checkForMatch() {
        guard selectedStars.count >= 3 else { return }
        
        let constellationStars = selectedStars.filter { $0.constellationType == currentConstellation }
        
        if constellationStars.count >= 3 {
            // Valid match found
            let matchScore = calculateScore(for: constellationStars.count)
            score += matchScore
            combo += 1
            
            // Add matched stars to set
            for star in constellationStars {
                matchedStars.insert(star.id)
            }
            
            // Create particles
            createParticles(at: constellationStars.map { $0.position })
            
            // Show combo if > 1
            if combo > 1 {
                showCombo()
            }
            
            // Clear selection
            clearSelection()
            
            // Check for level completion
            if matchedStars.count == stars.count {
                completeLevel()
            }
            
            if userService.hapticEnabled {
                hapticFeedback.impactOccurred()
            }
        } else {
            // Invalid match - penalty
            if combo > 0 {
                combo = 0
                score = max(0, score - 50)
            }
            clearSelection()
        }
    }
    
    private func calculateScore(for starCount: Int) -> Int {
        let baseScore = starCount * 100
        let comboBonus = combo * 50
        let difficultyMultiplier = userService.difficulty.scoreMultiplier
        
        return Int(Double(baseScore + comboBonus) * difficultyMultiplier)
    }
    
    private func clearSelection() {
        selectedStars.removeAll()
        for i in stars.indices {
            stars[i].isSelected = false
        }
    }
    
    private func completeLevel() {
        gameState = .completed
        gameTimer?.invalidate()
        
        // Show educational tip
        currentTip = currentConstellation.educationalTip
        showingEducationalTip = true
        
        // Bonus points for time remaining
        let timeBonus = Int(timeRemaining * 10)
        score += timeBonus
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            self.nextLevel()
        }
    }
    
    private func nextLevel() {
        level += 1
        showingEducationalTip = false
        
        // Select next constellation
        let allConstellations = Star.ConstellationType.allCases
        if let currentIndex = allConstellations.firstIndex(of: currentConstellation) {
            let nextIndex = (currentIndex + 1) % allConstellations.count
            currentConstellation = allConstellations[nextIndex]
        }
        
        // Reset for next level
        matchedStars.removeAll()
        selectedStars.removeAll()
        particles.removeAll()
        timeRemaining = userService.difficulty.timeLimit
        
        generateStars()
        gameState = .playing
        startTimer()
    }
    
    private func generateStars() {
        stars.removeAll()
        let screenWidth: CGFloat = 350
        let screenHeight: CGFloat = 600
        let starCount = userService.difficulty.starsCount
        
        // Generate constellation stars
        let constellationCount = max(3, starCount / 2)
        for i in 0..<constellationCount {
            let position = CGPoint(
                x: CGFloat.random(in: 50...(screenWidth - 50)),
                y: CGFloat.random(in: 100...(screenHeight - 100))
            )
            
            let star = Star(
                position: position,
                constellationType: currentConstellation,
                brightness: Double.random(in: 0.7...1.0)
            )
            stars.append(star)
        }
        
        // Generate random stars
        let randomCount = starCount - constellationCount
        let otherConstellations = Star.ConstellationType.allCases.filter { $0 != currentConstellation }
        
        for _ in 0..<randomCount {
            let position = CGPoint(
                x: CGFloat.random(in: 50...(screenWidth - 50)),
                y: CGFloat.random(in: 100...(screenHeight - 100))
            )
            
            let randomConstellation = otherConstellations.randomElement() ?? .orion
            let star = Star(
                position: position,
                constellationType: randomConstellation,
                brightness: Double.random(in: 0.5...0.9)
            )
            stars.append(star)
        }
        
        // Shuffle stars
        stars.shuffle()
    }
    
    private func startTimer() {
        gameTimer?.invalidate()
        gameTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            self.timeRemaining -= 0.1
            
            if self.timeRemaining <= 0 {
                self.endGame()
            }
        }
    }
    
    private func showCombo() {
        showingCombo = true
        comboTimer?.invalidate()
        comboTimer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) { _ in
            self.showingCombo = false
        }
    }
    
    private func createParticles(at positions: [CGPoint]) {
        for position in positions {
            for _ in 0..<5 {
                let particle = StarParticle(
                    position: position,
                    velocity: CGVector(
                        dx: Double.random(in: -50...50),
                        dy: Double.random(in: -50...50)
                    ),
                    color: currentConstellation.color
                )
                particles.append(particle)
            }
        }
        
        // Remove particles after animation
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.particles.removeAll()
        }
    }
    
    func resetGame() {
        gameState = .menu
        gameTimer?.invalidate()
        comboTimer?.invalidate()
        score = 0
        level = 1
        combo = 0
        timeRemaining = userService.difficulty.timeLimit
        matchedStars.removeAll()
        selectedStars.removeAll()
        particles.removeAll()
        showingEducationalTip = false
        showingCombo = false
        currentConstellation = .ursa
    }
    
    private func setupGame() {
        currentConstellation = Star.ConstellationType.allCases.randomElement() ?? .ursa
        timeRemaining = userService.difficulty.timeLimit
    }
    
    deinit {
        gameTimer?.invalidate()
        comboTimer?.invalidate()
    }
}

// MARK: - Tutorial Methods
extension GameViewModel {
    func startTutorial() {
        gameState = .tutorial
        generateTutorialStars()
    }
    
    private func generateTutorialStars() {
        stars.removeAll()
        currentConstellation = .ursa
        
        // Create simple tutorial pattern
        let tutorialPositions: [CGPoint] = [
            CGPoint(x: 100, y: 200),
            CGPoint(x: 150, y: 180),
            CGPoint(x: 200, y: 200),
            CGPoint(x: 250, y: 170),
            CGPoint(x: 120, y: 300),
            CGPoint(x: 180, y: 320),
            CGPoint(x: 230, y: 300)
        ]
        
        for (index, position) in tutorialPositions.enumerated() {
            let constellation: Star.ConstellationType = index < 4 ? .ursa : .orion
            let star = Star(
                position: position,
                constellationType: constellation,
                brightness: 1.0
            )
            stars.append(star)
        }
    }
    
    func completeTutorial() {
        gameState = .menu
        resetGame()
    }
}
