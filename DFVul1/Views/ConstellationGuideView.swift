//
//  ConstellationGuideView.swift
//  DFVul1
//
//  Created by IGOR on 04/09/2025.
//

import SwiftUI

struct ConstellationGuideView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selectedConstellation: Star.ConstellationType?
    @State private var searchText = ""
    @State private var selectedDifficulty: Int = 0 // 0 = All, 1-4 = specific difficulty
    
    var filteredConstellations: [Star.ConstellationType] {
        let filtered = Star.ConstellationType.allCases.filter { constellation in
            let matchesSearch = searchText.isEmpty || 
                constellation.rawValue.localizedCaseInsensitiveContains(searchText)
            let matchesDifficulty = selectedDifficulty == 0 || 
                constellation.difficulty == selectedDifficulty
            return matchesSearch && matchesDifficulty
        }
        return filtered.sorted { $0.rawValue < $1.rawValue }
    }
    
    var body: some View {
        NavigationView {
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
                
                // Background stars
                ForEach(0..<30, id: \.self) { index in
                    Circle()
                        .fill(Color.white.opacity(Double.random(in: 0.1...0.3)))
                        .frame(width: CGFloat.random(in: 1...3))
                        .position(
                            x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
                            y: CGFloat.random(in: 0...UIScreen.main.bounds.height)
                        )
                }
                
                VStack(spacing: 0) {
                    // Header
                    VStack(spacing: 16) {
                        HStack {
                            Image(systemName: "star.circle.fill")
                                .font(.system(size: 40))
                                .foregroundColor(Color(hex: "#ffbe00"))
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Constellation Guide")
                                    .font(.system(size: 24, weight: .bold))
                                    .foregroundColor(.white)
                                
                                Text("Learn about the stars")
                                    .font(.system(size: 14))
                                    .foregroundColor(.white.opacity(0.7))
                            }
                            
                            Spacer()
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                        
                        // Search and filter
                        VStack(spacing: 12) {
                            // Search bar
                            HStack {
                                Image(systemName: "magnifyingglass")
                                    .foregroundColor(.white.opacity(0.6))
                                
                                TextField("Search constellations...", text: $searchText)
                                    .foregroundColor(.white)
                                    .textFieldStyle(PlainTextFieldStyle())
                                
                                if !searchText.isEmpty {
                                    Button(action: { searchText = "" }) {
                                        Image(systemName: "xmark.circle.fill")
                                            .foregroundColor(.white.opacity(0.6))
                                    }
                                }
                            }
                            .padding(12)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.white.opacity(0.1))
                            )
                            .padding(.horizontal, 20)
                            
                            // Difficulty filter
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 12) {
                                    DifficultyFilterButton(
                                        title: "All",
                                        isSelected: selectedDifficulty == 0
                                    ) {
                                        selectedDifficulty = 0
                                    }
                                    
                                    DifficultyFilterButton(
                                        title: "Easy",
                                        isSelected: selectedDifficulty == 1
                                    ) {
                                        selectedDifficulty = 1
                                    }
                                    
                                    DifficultyFilterButton(
                                        title: "Medium",
                                        isSelected: selectedDifficulty == 2
                                    ) {
                                        selectedDifficulty = 2
                                    }
                                    
                                    DifficultyFilterButton(
                                        title: "Hard",
                                        isSelected: selectedDifficulty == 3
                                    ) {
                                        selectedDifficulty = 3
                                    }
                                    
                                    DifficultyFilterButton(
                                        title: "Expert",
                                        isSelected: selectedDifficulty == 4
                                    ) {
                                        selectedDifficulty = 4
                                    }
                                }
                                .padding(.horizontal, 20)
                            }
                        }
                    }
                    
                    // Constellation list
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(filteredConstellations, id: \.rawValue) { constellation in
                                ConstellationCard(constellation: constellation) {
                                    selectedConstellation = constellation
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 20)
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(Color(hex: "#ffbe00"))
                }
            }
        }
        .sheet(item: Binding<ConstellationWrapper?>(
            get: { selectedConstellation.map(ConstellationWrapper.init) },
            set: { _ in selectedConstellation = nil }
        )) { wrapper in
            ConstellationDetailView(constellation: wrapper.constellation)
        }
    }
}

struct ConstellationCard: View {
    let constellation: Star.ConstellationType
    let onTap: () -> Void
    
    var difficultyStars: String {
        String(repeating: "★", count: constellation.difficulty) +
        String(repeating: "☆", count: 4 - constellation.difficulty)
    }
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                // Constellation preview
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.black.opacity(0.3))
                        .frame(width: 80, height: 60)
                    
                    // Mini constellation pattern
                    ForEach(Array(constellation.pattern.prefix(5).enumerated()), id: \.offset) { index, point in
                        Circle()
                            .fill(constellation.color)
                            .frame(width: 4, height: 4)
                            .position(
                                x: 40 + point.x * 0.15,
                                y: 30 + point.y * 0.15
                            )
                    }
                }
                
                // Info
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text(constellation.rawValue)
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        Text(difficultyStars)
                            .font(.system(size: 12))
                            .foregroundColor(Color(hex: "#ffbe00"))
                    }
                    
                    Text(constellation.bestViewingTime)
                        .font(.system(size: 12))
                        .foregroundColor(.white.opacity(0.7))
                        .lineLimit(1)
                    
                    Text(constellation.educationalTip.components(separatedBy: ".").first ?? "")
                        .font(.system(size: 12))
                        .foregroundColor(.white.opacity(0.8))
                        .lineLimit(2)
                }
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14))
                    .foregroundColor(.white.opacity(0.5))
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white.opacity(0.1))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(constellation.color.opacity(0.3), lineWidth: 1)
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct DifficultyFilterButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(isSelected ? Color(hex: "#02102b") : .white)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(isSelected ? Color(hex: "#ffbe00") : Color.white.opacity(0.1))
                )
        }
    }
}

struct ConstellationDetailView: View {
    let constellation: Star.ConstellationType
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
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
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Header with constellation pattern
                        VStack(spacing: 20) {
                            Text(constellation.rawValue)
                                .font(.system(size: 32, weight: .bold))
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                            
                            // Large constellation pattern
                            ZStack {
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color.black.opacity(0.3))
                                    .frame(height: 200)
                                
                                ForEach(Array(constellation.pattern.enumerated()), id: \.offset) { index, point in
                                    Circle()
                                        .fill(constellation.color)
                                        .frame(width: 8, height: 8)
                                        .position(
                                            x: 150 + point.x * 0.8,
                                            y: 100 + point.y * 0.8
                                        )
                                }
                                
                                // Connect the dots with lines
                                Path { path in
                                    let points = constellation.pattern.map { point in
                                        CGPoint(
                                            x: 150 + point.x * 0.8,
                                            y: 100 + point.y * 0.8
                                        )
                                    }
                                    
                                    if !points.isEmpty {
                                        path.move(to: points[0])
                                        for point in points.dropFirst() {
                                            path.addLine(to: point)
                                        }
                                    }
                                }
                                .stroke(constellation.color.opacity(0.5), lineWidth: 2)
                            }
                            .padding(.horizontal, 20)
                        }
                        
                        // Info sections
                        VStack(spacing: 20) {
                            InfoSection(
                                title: "Description",
                                content: constellation.detailedDescription,
                                icon: "text.book.closed.fill"
                            )
                            
                            InfoSection(
                                title: "Best Viewing Time",
                                content: constellation.bestViewingTime,
                                icon: "clock.fill"
                            )
                            
                            InfoSection(
                                title: "Wellness Tip",
                                content: constellation.educationalTip,
                                icon: "heart.fill"
                            )
                            
                            // Difficulty
                            VStack(alignment: .leading, spacing: 12) {
                                HStack {
                                    Image(systemName: "star.fill")
                                        .font(.system(size: 16))
                                        .foregroundColor(Color(hex: "#ffbe00"))
                                    
                                    Text("Difficulty Level")
                                        .font(.system(size: 18, weight: .semibold))
                                        .foregroundColor(.white)
                                }
                                
                                HStack {
                                    ForEach(1...4, id: \.self) { level in
                                        Image(systemName: level <= constellation.difficulty ? "star.fill" : "star")
                                            .font(.system(size: 20))
                                            .foregroundColor(Color(hex: "#ffbe00"))
                                    }
                                    
                                    Spacer()
                                    
                                    Text(difficultyText)
                                        .font(.system(size: 14, weight: .medium))
                                        .foregroundColor(.white.opacity(0.8))
                                }
                            }
                            .padding(20)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color.white.opacity(0.1))
                            )
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 40)
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") {
                        dismiss()
                    }
                    .foregroundColor(Color(hex: "#ffbe00"))
                }
            }
        }
    }
    
    private var difficultyText: String {
        switch constellation.difficulty {
        case 1: return "Easy to find"
        case 2: return "Moderate difficulty"
        case 3: return "Challenging"
        case 4: return "Expert level"
        default: return "Unknown"
        }
    }
}

struct InfoSection: View {
    let title: String
    let content: String
    let icon: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 16))
                    .foregroundColor(Color(hex: "#ffbe00"))
                
                Text(title)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
            }
            
            Text(content)
                .font(.system(size: 14))
                .foregroundColor(.white.opacity(0.8))
                .lineSpacing(4)
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.1))
        )
    }
}

// Wrapper to make ConstellationType identifiable for sheet
struct ConstellationWrapper: Identifiable {
    let id = UUID()
    let constellation: Star.ConstellationType
}

#Preview {
    ConstellationGuideView()
}
