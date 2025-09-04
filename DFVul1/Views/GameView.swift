//
//  GameView.swift
//  DFVul1
//
//  Created by IGOR on 04/09/2025.
//

import SwiftUI

struct GameView: View {
    @StateObject private var viewModel = GameViewModel()
    @Environment(\.dismiss) private var dismiss
    @State private var showingPauseMenu = false
    @State private var showingGameOver = false
    
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
            
            // Background stars
            ForEach(0..<100, id: \.self) { index in
                Circle()
                    .fill(Color.white.opacity(Double.random(in: 0.1...0.4)))
                    .frame(width: CGFloat.random(in: 1...2))
                    .position(
                        x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
                        y: CGFloat.random(in: 0...UIScreen.main.bounds.height)
                    )
            }
            
            VStack(spacing: 0) {
                // Header
                GameHeaderView(
                    score: viewModel.score,
                    timeRemaining: viewModel.timeRemaining,
                    level: viewModel.level,
                    constellation: viewModel.currentConstellation,
                    onPause: {
                        viewModel.pauseGame()
                        showingPauseMenu = true
                    },
                    onBack: {
                        dismiss()
                    }
                )
                
                // Game area
                GeometryReader { geometry in
                    ZStack {
                        // Game stars
                        ForEach(viewModel.stars) { star in
                            StarView(
                                star: star,
                                isMatched: viewModel.matchedStars.contains(star.id),
                                onTap: {
                                    viewModel.selectStar(star)
                                }
                            )
                        }
                        
                        // Particles
                        ForEach(viewModel.particles) { particle in
                            Circle()
                                .fill(particle.color)
                                .frame(width: 4, height: 4)
                                .position(particle.position)
                                .opacity(particle.life)
                        }
                        
                        // Combo indicator
                        if viewModel.showingCombo && viewModel.combo > 1 {
                            VStack {
                                Text("COMBO x\(viewModel.combo)")
                                    .font(.system(size: 24, weight: .bold))
                                    .foregroundColor(Color(hex: "#ffbe00"))
                                    .shadow(color: .black, radius: 2)
                                
                                Text("+\(viewModel.combo * 50) BONUS")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.white)
                                    .shadow(color: .black, radius: 1)
                            }
                            .position(x: geometry.size.width / 2, y: 100)
                            .scaleEffect(1.2)
                            .animation(.spring(), value: viewModel.showingCombo)
                        }
                    }
                }
                
                // Bottom UI
                GameBottomView(
                    selectedCount: viewModel.selectedStars.count,
                    targetConstellation: viewModel.currentConstellation,
                    matchedCount: viewModel.matchedStars.count,
                    totalStars: viewModel.stars.filter { $0.constellationType == viewModel.currentConstellation }.count
                )
            }
            
            // Overlays
            if viewModel.gameState == .paused {
                PauseMenuView(
                    onResume: {
                        showingPauseMenu = false
                        viewModel.resumeGame()
                    },
                    onRestart: {
                        showingPauseMenu = false
                        viewModel.startGame()
                    },
                    onQuit: {
                        dismiss()
                    }
                )
                .transition(.opacity)
            }
            
            if viewModel.gameState == .gameOver {
                GameOverView(
                    score: viewModel.score,
                    level: viewModel.level,
                    matchedStars: viewModel.matchedStars.count,
                    totalStars: viewModel.stars.count,
                    onRestart: {
                        viewModel.startGame()
                    },
                    onQuit: {
                        dismiss()
                    }
                )
                .transition(.opacity)
            }
            
            if viewModel.showingEducationalTip {
                EducationalTipView(
                    tip: viewModel.currentTip,
                    constellation: viewModel.currentConstellation,
                    onDismiss: {
                        viewModel.showingEducationalTip = false
                    }
                )
                .transition(.opacity)
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            viewModel.startGame()
        }
        .onChange(of: viewModel.gameState) { state in
            if state == .gameOver {
                showingGameOver = true
            }
        }
    }
}

struct GameHeaderView: View {
    let score: Int
    let timeRemaining: TimeInterval
    let level: Int
    let constellation: Star.ConstellationType
    let onPause: () -> Void
    let onBack: () -> Void
    
    var body: some View {
        HStack {
            // Back button
            Button(action: onBack) {
                Image(systemName: "chevron.left")
                    .font(.title2)
                    .foregroundColor(.white)
            }
            
            Spacer()
            
            // Score and level
            VStack(alignment: .center, spacing: 2) {
                Text("Level \(level)")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.white.opacity(0.8))
                
                Text("\(score)")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(Color(hex: "#ffbe00"))
            }
            
            Spacer()
            
            // Timer
            VStack(alignment: .center, spacing: 2) {
                Text("Time")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.white.opacity(0.8))
                
                Text(timeString(from: timeRemaining))
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(timeRemaining < 10 ? Color(hex: "#bd0e1b") : .white)
                    .animation(.easeInOut, value: timeRemaining < 10)
            }
            
            Spacer()
            
            // Pause button
            Button(action: onPause) {
                Image(systemName: "pause.fill")
                    .font(.title2)
                    .foregroundColor(.white)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
        
        // Constellation info
        HStack {
            Image(systemName: "star.fill")
                .foregroundColor(constellation.color)
                .font(.system(size: 16))
            
            Text("Find: \(constellation.rawValue)")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.white)
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 10)
    }
    
    private func timeString(from timeInterval: TimeInterval) -> String {
        let minutes = Int(timeInterval) / 60
        let seconds = Int(timeInterval) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
}

struct StarView: View {
    let star: Star
    let isMatched: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            ZStack {
                // Glow effect
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                star.constellationType.color.opacity(0.6),
                                star.constellationType.color.opacity(0.2),
                                Color.clear
                            ],
                            center: .center,
                            startRadius: 0,
                            endRadius: 15
                        )
                    )
                    .frame(width: 30, height: 30)
                    .opacity(star.isSelected ? 1.0 : 0.3)
                
                // Star
                Image(systemName: "star.fill")
                    .font(.system(size: 16))
                    .foregroundColor(star.constellationType.color)
                    .opacity(star.brightness)
                    .scaleEffect(star.isSelected ? 1.3 : 1.0)
                    .scaleEffect(isMatched ? 0.8 : 1.0)
                
                // Selection ring
                if star.isSelected {
                    Circle()
                        .stroke(Color.white, lineWidth: 2)
                        .frame(width: 24, height: 24)
                }
                
                // Matched indicator
                if isMatched {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 12))
                        .foregroundColor(.white)
                        .background(Color(hex: "#02102b"))
                        .clipShape(Circle())
                        .offset(x: 10, y: -10)
                }
            }
        }
        .position(star.position)
        .animation(.spring(response: 0.3), value: star.isSelected)
        .animation(.spring(response: 0.3), value: isMatched)
        .disabled(isMatched)
    }
}

struct GameBottomView: View {
    let selectedCount: Int
    let targetConstellation: Star.ConstellationType
    let matchedCount: Int
    let totalStars: Int
    
    var body: some View {
        VStack(spacing: 12) {
            // Progress bar
            HStack {
                Text("Progress")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.white.opacity(0.8))
                
                Spacer()
                
                Text("\(matchedCount)/\(totalStars)")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(Color(hex: "#ffbe00"))
            }
            
            ProgressView(value: Double(matchedCount), total: Double(totalStars))
                .progressViewStyle(LinearProgressViewStyle(tint: targetConstellation.color))
                .scaleEffect(y: 2)
            
            // Selection info
            HStack {
                HStack(spacing: 8) {
                    Image(systemName: "hand.tap.fill")
                        .foregroundColor(.white.opacity(0.6))
                        .font(.system(size: 14))
                    
                    Text("Selected: \(selectedCount)")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.white.opacity(0.8))
                }
                
                Spacer()
                
                Text("Need 3+ \(targetConstellation.rawValue) stars")
                    .font(.system(size: 12))
                    .foregroundColor(.white.opacity(0.6))
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.black.opacity(0.3))
        )
        .padding(.horizontal, 16)
        .padding(.bottom, 20)
    }
}

struct PauseMenuView: View {
    let onResume: () -> Void
    let onRestart: () -> Void
    let onQuit: () -> Void
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.7)
                .ignoresSafeArea()
            
            VStack(spacing: 24) {
                Text("Game Paused")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.white)
                
                VStack(spacing: 16) {
                    MenuButton(title: "Resume", icon: "play.fill", action: onResume)
                    MenuButton(title: "Restart", icon: "arrow.clockwise", action: onRestart)
                    MenuButton(title: "Quit", icon: "xmark", action: onQuit, isDestructive: true)
                }
            }
            .padding(40)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color(hex: "#0a1a3b"))
            )
            .padding(.horizontal, 40)
        }
    }
}

struct GameOverView: View {
    let score: Int
    let level: Int
    let matchedStars: Int
    let totalStars: Int
    let onRestart: () -> Void
    let onQuit: () -> Void
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.8)
                .ignoresSafeArea()
            
            VStack(spacing: 24) {
                Text("Game Over")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.white)
                
                VStack(spacing: 12) {
                    StatRow(label: "Final Score", value: "\(score)")
                    StatRow(label: "Level Reached", value: "\(level)")
                    StatRow(label: "Stars Matched", value: "\(matchedStars)/\(totalStars)")
                    
                    if matchedStars == totalStars {
                        Text("Perfect Game! 🌟")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(Color(hex: "#ffbe00"))
                            .padding(.top, 8)
                    }
                }
                .padding(20)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.black.opacity(0.3))
                )
                
                VStack(spacing: 16) {
                    MenuButton(title: "Play Again", icon: "arrow.clockwise", action: onRestart)
                    MenuButton(title: "Main Menu", icon: "house", action: onQuit, isDestructive: true)
                }
            }
            .padding(40)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color(hex: "#0a1a3b"))
            )
            .padding(.horizontal, 40)
        }
    }
}

struct StatRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label)
                .font(.system(size: 16))
                .foregroundColor(.white.opacity(0.8))
            
            Spacer()
            
            Text(value)
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(Color(hex: "#ffbe00"))
        }
    }
}

struct EducationalTipView: View {
    let tip: String
    let constellation: Star.ConstellationType
    let onDismiss: () -> Void
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.8)
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Image(systemName: "star.circle.fill")
                    .font(.system(size: 60))
                    .foregroundColor(constellation.color)
                
                Text("Constellation Unlocked!")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.white)
                
                Text(constellation.rawValue)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(constellation.color)
                
                Text(tip)
                    .font(.system(size: 16))
                    .foregroundColor(.white.opacity(0.9))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
                
                Button("Continue") {
                    onDismiss()
                }
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(Color(hex: "#02102b"))
                .frame(width: 200, height: 50)
                .background(Color(hex: "#ffbe00"))
                .cornerRadius(25)
            }
            .padding(30)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color(hex: "#0a1a3b"))
            )
            .padding(.horizontal, 30)
        }
    }
}

struct MenuButton: View {
    let title: String
    let icon: String
    let action: () -> Void
    var isDestructive: Bool = false
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .semibold))
                
                Text(title)
                    .font(.system(size: 18, weight: .semibold))
            }
            .foregroundColor(isDestructive ? Color(hex: "#bd0e1b") : Color(hex: "#02102b"))
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(isDestructive ? Color.white : Color(hex: "#ffbe00"))
            .cornerRadius(25)
        }
    }
}

#Preview {
    GameView()
}
