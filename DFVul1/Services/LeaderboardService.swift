//
//  LeaderboardService.swift
//  DFVul1
//
//  Created by IGOR on 04/09/2025.
//

import Foundation
import Combine

class LeaderboardService: ObservableObject {
    @Published var globalLeaderboard: [LeaderboardEntry] = []
    @Published var friendsLeaderboard: [LeaderboardEntry] = []
    @Published var isLoading = false
    
    private let userDefaults = UserDefaults.standard
    private let leaderboardKey = "starMatch_leaderboard"
    private let friendsKey = "starMatch_friends"
    
    init() {
        loadLeaderboard()
        generateSampleData()
    }
    
    func submitScore(_ entry: LeaderboardEntry) {
        globalLeaderboard.append(entry)
        globalLeaderboard.sort { $0.score > $1.score }
        
        // Keep only top 100 entries
        if globalLeaderboard.count > 100 {
            globalLeaderboard = Array(globalLeaderboard.prefix(100))
        }
        
        saveLeaderboard()
    }
    
    func addFriend(name: String) {
        let friendEntry = LeaderboardEntry(
            playerName: name,
            score: Int.random(in: 500...5000),
            level: Int.random(in: 1...10),
            constellationsCompleted: Int.random(in: 1...8)
        )
        friendsLeaderboard.append(friendEntry)
        friendsLeaderboard.sort { $0.score > $1.score }
        saveFriends()
    }
    
    func removeFriend(at index: Int) {
        guard index < friendsLeaderboard.count else { return }
        friendsLeaderboard.remove(at: index)
        saveFriends()
    }
    
    func refreshLeaderboard() {
        isLoading = true
        
        // Simulate network delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.generateRandomEntries()
            self.isLoading = false
        }
    }
    
    func getPlayerRank(score: Int) -> Int? {
        guard let index = globalLeaderboard.firstIndex(where: { $0.score <= score }) else {
            return globalLeaderboard.count + 1
        }
        return index + 1
    }
    
    func getTopPlayers(count: Int = 10) -> [LeaderboardEntry] {
        return Array(globalLeaderboard.prefix(count))
    }
    
    func getFriendsRank(score: Int) -> Int? {
        guard let index = friendsLeaderboard.firstIndex(where: { $0.score <= score }) else {
            return friendsLeaderboard.count + 1
        }
        return index + 1
    }
    
    private func loadLeaderboard() {
        if let data = userDefaults.data(forKey: leaderboardKey),
           let entries = try? JSONDecoder().decode([LeaderboardEntry].self, from: data) {
            globalLeaderboard = entries
        }
        
        if let data = userDefaults.data(forKey: friendsKey),
           let entries = try? JSONDecoder().decode([LeaderboardEntry].self, from: data) {
            friendsLeaderboard = entries
        }
    }
    
    private func saveLeaderboard() {
        if let data = try? JSONEncoder().encode(globalLeaderboard) {
            userDefaults.set(data, forKey: leaderboardKey)
        }
    }
    
    private func saveFriends() {
        if let data = try? JSONEncoder().encode(friendsLeaderboard) {
            userDefaults.set(data, forKey: friendsKey)
        }
    }
    
    private func generateSampleData() {
        if globalLeaderboard.isEmpty {
            let sampleNames = [
                "StarGazer", "CosmicMaster", "NebulaNinja", "GalaxyGuardian", "AstroAce",
                "StellarSage", "OrionHunter", "CassiopeiaQueen", "DracoSlayer", "LyraLegend",
                "CygnusChampion", "AquilaAdept", "PerseusProdigy", "UrsaMajor", "VegaVirtuoso",
                "SiriusSeeker", "PolarisProud", "AndromedaAce", "CentaurusChief", "PhoenixFlyer"
            ]
            
            for name in sampleNames {
                let entry = LeaderboardEntry(
                    playerName: name,
                    score: Int.random(in: 1000...15000),
                    level: Int.random(in: 5...20),
                    constellationsCompleted: Int.random(in: 3...8)
                )
                globalLeaderboard.append(entry)
            }
            
            globalLeaderboard.sort { $0.score > $1.score }
            saveLeaderboard()
        }
        
        if friendsLeaderboard.isEmpty {
            let friendNames = ["Alex", "Sarah", "Mike", "Emma", "David"]
            for name in friendNames {
                let entry = LeaderboardEntry(
                    playerName: name,
                    score: Int.random(in: 800...8000),
                    level: Int.random(in: 2...12),
                    constellationsCompleted: Int.random(in: 1...6)
                )
                friendsLeaderboard.append(entry)
            }
            
            friendsLeaderboard.sort { $0.score > $1.score }
            saveFriends()
        }
    }
    
    private func generateRandomEntries() {
        let newNames = [
            "StarSeeker\(Int.random(in: 100...999))",
            "CosmicRider\(Int.random(in: 100...999))",
            "GalaxyExplorer\(Int.random(in: 100...999))"
        ]
        
        for name in newNames {
            let entry = LeaderboardEntry(
                playerName: name,
                score: Int.random(in: 2000...12000),
                level: Int.random(in: 8...15),
                constellationsCompleted: Int.random(in: 2...7)
            )
            globalLeaderboard.append(entry)
        }
        
        globalLeaderboard.sort { $0.score > $1.score }
        
        // Keep only top 100
        if globalLeaderboard.count > 100 {
            globalLeaderboard = Array(globalLeaderboard.prefix(100))
        }
        
        saveLeaderboard()
    }
}

extension LeaderboardService {
    static let shared = LeaderboardService()
}
