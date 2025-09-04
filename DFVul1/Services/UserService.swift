//
//  UserService.swift
//  DFVul1
//
//  Created by IGOR on 04/09/2025.
//

import Foundation
import Combine

class UserService: ObservableObject {
    @Published var userProgress: UserProgress = UserProgress()
    @Published var selectedAvatar: String = "avatar_ursa_major"
    @Published var playerName: String = "Player"
    @Published var soundEnabled: Bool = true
    @Published var musicEnabled: Bool = true
    @Published var hapticEnabled: Bool = true
    @Published var difficulty: GameDifficulty = .normal
    
    private let userDefaults = UserDefaults.standard
    private let progressKey = "starMatch_userProgress"
    private let settingsKey = "starMatch_settings"
    
    enum GameDifficulty: String, CaseIterable, Codable {
        case easy = "easy"
        case normal = "normal"
        case hard = "hard"
        case expert = "expert"
        
        var displayName: String {
            switch self {
            case .easy: return "Easy"
            case .normal: return "Normal"
            case .hard: return "Hard"
            case .expert: return "Expert"
            }
        }
        
        var timeLimit: TimeInterval {
            switch self {
            case .easy: return 120.0    // 2 minutes
            case .normal: return 90.0   // 1.5 minutes
            case .hard: return 60.0     // 1 minute
            case .expert: return 45.0   // 45 seconds
            }
        }
        
        var scoreMultiplier: Double {
            switch self {
            case .easy: return 1.0
            case .normal: return 1.5
            case .hard: return 2.0
            case .expert: return 3.0
            }
        }
        
        var starsCount: Int {
            switch self {
            case .easy: return 5
            case .normal: return 7
            case .hard: return 9
            case .expert: return 12
            }
        }
    }
    
    init() {
        loadUserData()
        loadSettings()
    }
    
    func updateScore(_ score: Int) {
        userProgress.updateScore(score)
        saveUserData()
        
        // Submit to leaderboard
        let entry = LeaderboardEntry(
            playerName: playerName,
            score: score,
            level: userProgress.currentLevel,
            constellationsCompleted: userProgress.completedConstellations.count
        )
        LeaderboardService.shared.submitScore(entry)
    }
    
    func completeConstellation(_ constellation: Star.ConstellationType) {
        userProgress.completeConstellation(constellation)
        saveUserData()
    }
    
    func addStarsMatched(_ count: Int) {
        userProgress.addStarsMatched(count)
        saveUserData()
    }
    
    func recordPerfectGame() {
        userProgress.recordPerfectGame()
        saveUserData()
    }
    
    func recordTime(_ time: TimeInterval) {
        userProgress.recordTime(time)
        saveUserData()
    }
    
    func resetStreak() {
        userProgress.resetStreak()
        saveUserData()
    }
    
    func levelUp() {
        if userProgress.shouldLevelUp {
            userProgress.levelUp()
            saveUserData()
        }
    }
    
    func updatePlayerName(_ name: String) {
        playerName = name.isEmpty ? "Player" : name
        saveSettings()
    }
    
    func updateAvatar(_ avatarId: String) {
        if userProgress.unlockedAvatars.contains(avatarId) || avatarId == "avatar_ursa_major" {
            selectedAvatar = avatarId
            saveSettings()
        }
    }
    
    func updateSoundSettings(sound: Bool, music: Bool, haptic: Bool) {
        soundEnabled = sound
        musicEnabled = music
        hapticEnabled = haptic
        saveSettings()
    }
    
    func updateDifficulty(_ newDifficulty: GameDifficulty) {
        difficulty = newDifficulty
        saveSettings()
    }
    
    func resetProgress() {
        userProgress = UserProgress()
        selectedAvatar = "avatar_ursa_major"
        saveUserData()
        saveSettings()
    }
    
    func getAvailableAvatars() -> [StarAvatar] {
        return Star.ConstellationType.allCases.map { constellation in
            let avatarId = "avatar_\(constellation.rawValue.lowercased().replacingOccurrences(of: " ", with: "_"))"
            return StarAvatar(
                id: avatarId,
                name: constellation.rawValue,
                constellation: constellation,
                isUnlocked: userProgress.unlockedAvatars.contains(avatarId) || avatarId == "avatar_ursa_major"
            )
        }
    }
    
    func exportProgress() -> String? {
        guard let data = try? JSONEncoder().encode(userProgress),
              let jsonString = String(data: data, encoding: .utf8) else {
            return nil
        }
        return jsonString
    }
    
    func importProgress(from jsonString: String) -> Bool {
        guard let data = jsonString.data(using: .utf8),
              let progress = try? JSONDecoder().decode(UserProgress.self, from: data) else {
            return false
        }
        
        userProgress = progress
        saveUserData()
        return true
    }
    
    private func loadUserData() {
        if let data = userDefaults.data(forKey: progressKey),
           let progress = try? JSONDecoder().decode(UserProgress.self, from: data) {
            userProgress = progress
        }
    }
    
    private func saveUserData() {
        if let data = try? JSONEncoder().encode(userProgress) {
            userDefaults.set(data, forKey: progressKey)
        }
    }
    
    private func loadSettings() {
        if let data = userDefaults.data(forKey: settingsKey),
           let settings = try? JSONDecoder().decode(UserSettings.self, from: data) {
            selectedAvatar = settings.selectedAvatar
            playerName = settings.playerName
            soundEnabled = settings.soundEnabled
            musicEnabled = settings.musicEnabled
            hapticEnabled = settings.hapticEnabled
            difficulty = settings.difficulty
        }
    }
    
    private func saveSettings() {
        let settings = UserSettings(
            selectedAvatar: selectedAvatar,
            playerName: playerName,
            soundEnabled: soundEnabled,
            musicEnabled: musicEnabled,
            hapticEnabled: hapticEnabled,
            difficulty: difficulty
        )
        
        if let data = try? JSONEncoder().encode(settings) {
            userDefaults.set(data, forKey: settingsKey)
        }
    }
}

private struct UserSettings: Codable {
    let selectedAvatar: String
    let playerName: String
    let soundEnabled: Bool
    let musicEnabled: Bool
    let hapticEnabled: Bool
    let difficulty: UserService.GameDifficulty
}

extension UserService {
    static let shared = UserService()
}
