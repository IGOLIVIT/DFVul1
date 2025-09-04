//
//  UserProgress.swift
//  DFVul1
//
//  Created by IGOR on 04/09/2025.
//

import Foundation
import SwiftUI

struct UserProgress: Codable {
    var currentLevel: Int = 1
    var totalScore: Int = 0
    var highScore: Int = 0
    var completedConstellations: Set<String> = []
    var unlockedAvatars: Set<String> = []
    var achievements: [Achievement] = []
    var gamesPlayed: Int = 0
    var totalStarsMatched: Int = 0
    var perfectGames: Int = 0
    var streakCount: Int = 0
    var bestTime: TimeInterval = 0
    
    mutating func updateScore(_ newScore: Int) {
        totalScore += newScore
        if newScore > highScore {
            highScore = newScore
        }
        gamesPlayed += 1
        checkForAchievements()
    }
    
    mutating func completeConstellation(_ constellation: Star.ConstellationType) {
        completedConstellations.insert(constellation.rawValue)
        unlockAvatar(for: constellation)
        checkForAchievements()
    }
    
    mutating func addStarsMatched(_ count: Int) {
        totalStarsMatched += count
        checkForAchievements()
    }
    
    mutating func recordPerfectGame() {
        perfectGames += 1
        streakCount += 1
        checkForAchievements()
    }
    
    mutating func recordTime(_ time: TimeInterval) {
        if bestTime == 0 || time < bestTime {
            bestTime = time
        }
    }
    
    mutating func resetStreak() {
        streakCount = 0
    }
    
    private mutating func unlockAvatar(for constellation: Star.ConstellationType) {
        let avatarId = "avatar_\(constellation.rawValue.lowercased().replacingOccurrences(of: " ", with: "_"))"
        unlockedAvatars.insert(avatarId)
    }
    
    private mutating func checkForAchievements() {
        // First constellation
        if completedConstellations.count == 1 && !hasAchievement(.firstConstellation) {
            achievements.append(Achievement(.firstConstellation))
        }
        
        // Constellation master
        if completedConstellations.count >= 5 && !hasAchievement(.constellationMaster) {
            achievements.append(Achievement(.constellationMaster))
        }
        
        // Score milestones
        if totalScore >= 1000 && !hasAchievement(.scoreThousand) {
            achievements.append(Achievement(.scoreThousand))
        }
        
        if totalScore >= 10000 && !hasAchievement(.scoreTenThousand) {
            achievements.append(Achievement(.scoreTenThousand))
        }
        
        // Star matcher
        if totalStarsMatched >= 100 && !hasAchievement(.starMatcher) {
            achievements.append(Achievement(.starMatcher))
        }
        
        // Perfect streak
        if streakCount >= 5 && !hasAchievement(.perfectStreak) {
            achievements.append(Achievement(.perfectStreak))
        }
        
        // Speed demon
        if bestTime > 0 && bestTime <= 30 && !hasAchievement(.speedDemon) {
            achievements.append(Achievement(.speedDemon))
        }
        
        // Dedicated player
        if gamesPlayed >= 50 && !hasAchievement(.dedicatedPlayer) {
            achievements.append(Achievement(.dedicatedPlayer))
        }
    }
    
    private func hasAchievement(_ type: Achievement.AchievementType) -> Bool {
        return achievements.contains { $0.type == type }
    }
    
    var currentLevelProgress: Double {
        let baseScore = (currentLevel - 1) * 1000
        let nextLevelScore = currentLevel * 1000
        let currentProgress = totalScore - baseScore
        let levelRange = nextLevelScore - baseScore
        return Double(currentProgress) / Double(levelRange)
    }
    
    var shouldLevelUp: Bool {
        return totalScore >= currentLevel * 1000
    }
    
    mutating func levelUp() {
        if shouldLevelUp {
            currentLevel += 1
        }
    }
}

struct Achievement: Codable, Identifiable {
    let id = UUID()
    let type: AchievementType
    let unlockedDate: Date
    
    init(_ type: AchievementType) {
        self.type = type
        self.unlockedDate = Date()
    }
    
    enum AchievementType: String, CaseIterable, Codable {
        case firstConstellation = "first_constellation"
        case constellationMaster = "constellation_master"
        case scoreThousand = "score_thousand"
        case scoreTenThousand = "score_ten_thousand"
        case starMatcher = "star_matcher"
        case perfectStreak = "perfect_streak"
        case speedDemon = "speed_demon"
        case dedicatedPlayer = "dedicated_player"
        
        var title: String {
            switch self {
            case .firstConstellation: return "First Light"
            case .constellationMaster: return "Constellation Master"
            case .scoreThousand: return "Rising Star"
            case .scoreTenThousand: return "Stellar Champion"
            case .starMatcher: return "Star Matcher"
            case .perfectStreak: return "Perfect Streak"
            case .speedDemon: return "Speed Demon"
            case .dedicatedPlayer: return "Dedicated Astronomer"
            }
        }
        
        var description: String {
            switch self {
            case .firstConstellation: return "Complete your first constellation"
            case .constellationMaster: return "Complete 5 different constellations"
            case .scoreThousand: return "Reach 1,000 points"
            case .scoreTenThousand: return "Reach 10,000 points"
            case .starMatcher: return "Match 100 stars"
            case .perfectStreak: return "Get 5 perfect games in a row"
            case .speedDemon: return "Complete a level in under 30 seconds"
            case .dedicatedPlayer: return "Play 50 games"
            }
        }
        
        var icon: String {
            switch self {
            case .firstConstellation: return "star.fill"
            case .constellationMaster: return "star.circle.fill"
            case .scoreThousand: return "flame.fill"
            case .scoreTenThousand: return "crown.fill"
            case .starMatcher: return "sparkles"
            case .perfectStreak: return "bolt.fill"
            case .speedDemon: return "timer"
            case .dedicatedPlayer: return "heart.fill"
            }
        }
    }
}

struct LeaderboardEntry: Codable, Identifiable {
    let id = UUID()
    let playerName: String
    let score: Int
    let level: Int
    let date: Date
    let constellationsCompleted: Int
    
    init(playerName: String, score: Int, level: Int, constellationsCompleted: Int) {
        self.playerName = playerName
        self.score = score
        self.level = level
        self.date = Date()
        self.constellationsCompleted = constellationsCompleted
    }
}

struct StarAvatar: Identifiable, Codable {
    let id: String
    let name: String
    let constellation: Star.ConstellationType
    let isUnlocked: Bool
    
    var imageName: String {
        return "avatar_\(constellation.rawValue.lowercased().replacingOccurrences(of: " ", with: "_"))"
    }
}
