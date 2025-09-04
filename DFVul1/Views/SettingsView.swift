//
//  SettingsView.swift
//  DFVul1
//
//  Created by IGOR on 04/09/2025.
//

import SwiftUI

struct SettingsView: View {
    @StateObject private var userService = UserService.shared
    @Environment(\.dismiss) private var dismiss
    
    @State private var showingResetAlert = false
    
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
                        // Header
                        VStack(spacing: 16) {
                            Image(systemName: "gearshape.fill")
                                .font(.system(size: 60))
                                .foregroundColor(Color(hex: "#ffbe00"))
                            
                            Text("Settings")
                                .font(.system(size: 28, weight: .bold))
                                .foregroundColor(.white)
                        }
                        .padding(.top, 20)
                        
                        
                        // Game Settings Section
                        SettingsSection(title: "Game Settings") {
                            ToggleRow(
                                title: "Haptic Feedback",
                                icon: "iphone.radiowaves.left.and.right",
                                isOn: $userService.hapticEnabled
                            )
                        }
                        
                        // Progress Section
                        SettingsSection(title: "Progress") {
                            VStack(spacing: 16) {
                                // Stats
                                StatsGrid(userProgress: userService.userProgress)
                                
                                // Reset Button
                                ActionButton(
                                    title: "Reset Progress",
                                    icon: "arrow.clockwise",
                                    color: Color(hex: "#bd0e1b")
                                ) {
                                    showingResetAlert = true
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 40)
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
        .alert("Reset Progress", isPresented: $showingResetAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Reset", role: .destructive) {
                userService.resetProgress()
            }
        } message: {
            Text("This will permanently delete all your progress, achievements, and unlocked avatars. This action cannot be undone.")
        }
    }
}

struct SettingsSection<Content: View>: View {
    let title: String
    let content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(title)
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.white)
            
            content
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.black.opacity(0.3))
        )
    }
}

struct ToggleRow: View {
    let title: String
    let icon: String
    @Binding var isOn: Bool
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.system(size: 18))
                .foregroundColor(Color(hex: "#ffbe00"))
                .frame(width: 24)
            
            Text(title)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.white)
            
            Spacer()
            
            Toggle("", isOn: $isOn)
                .toggleStyle(SwitchToggleStyle(tint: Color(hex: "#ffbe00")))
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white.opacity(0.1))
        )
    }
}

struct StatsGrid: View {
    let userProgress: UserProgress
    
    var body: some View {
        LazyVGrid(columns: [
            GridItem(.flexible()),
            GridItem(.flexible())
        ], spacing: 12) {
            StatCard(title: "Level", value: "\(userProgress.currentLevel)")
            StatCard(title: "High Score", value: "\(userProgress.highScore)")
            StatCard(title: "Games Played", value: "\(userProgress.gamesPlayed)")
            StatCard(title: "Constellations", value: "\(userProgress.completedConstellations.count)")
        }
    }
}

struct StatCard: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack(spacing: 8) {
            Text(value)
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(Color(hex: "#ffbe00"))
            
            Text(title)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(.white.opacity(0.8))
        }
        .frame(maxWidth: .infinity)
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white.opacity(0.1))
        )
    }
}

struct ActionButton: View {
    let title: String
    let icon: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .semibold))
                
                Text(title)
                    .font(.system(size: 16, weight: .semibold))
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 12))
            }
            .foregroundColor(color)
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white.opacity(0.1))
            )
        }
    }
}




#Preview {
    SettingsView()
}
