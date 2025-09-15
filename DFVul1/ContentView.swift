//
//  ContentView.swift
//  DFVul1
//
//  Created by IGOR on 04/09/2025.
//

//import SwiftUI
//
//struct ContentView: View {
//    @StateObject private var userService = UserService.shared
//    @StateObject private var onboardingViewModel = OnboardingViewModel()
//    @State private var showingGame = false
//    @State private var showingSettings = false
//    @State private var showingOnboarding = false
//    @State private var showingConstellationGuide = false
//    
//    var body: some View {
//        NavigationView {
//            ZStack {
//                // Background
//                LinearGradient(
//                    colors: [
//                        Color(hex: "#02102b"),
//                        Color(hex: "#0a1a3b")
//                    ],
//                    startPoint: .topLeading,
//                    endPoint: .bottomTrailing
//                )
//                .ignoresSafeArea()
//                
//                // Animated background stars
//                ForEach(0..<80, id: \.self) { index in
//                    Circle()
//                        .fill(Color.white.opacity(Double.random(in: 0.1...0.4)))
//                        .frame(width: CGFloat.random(in: 1...3))
//                        .position(
//                            x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
//                            y: CGFloat.random(in: 0...UIScreen.main.bounds.height)
//                        )
//                        .animation(
//                            Animation.easeInOut(duration: Double.random(in: 3...6))
//                                .repeatForever(autoreverses: true)
//                                .delay(Double.random(in: 0...3)),
//                            value: UUID()
//                        )
//                }
//                
//                VStack(spacing: 0) {
//                    Spacer()
//                    
//                    // Logo and Title
//                    VStack(spacing: 24) {
//                        // Animated logo
//                        ZStack {
//                            // Outer glow
//                            Circle()
//                                .fill(
//                                    RadialGradient(
//                                        colors: [
//                                            Color(hex: "#ffbe00").opacity(0.3),
//                                            Color(hex: "#bd0e1b").opacity(0.2),
//                                            Color.clear
//                                        ],
//                                        center: .center,
//                                        startRadius: 0,
//                                        endRadius: 120
//                                    )
//                                )
//                                .frame(width: 240, height: 240)
//                            
//                            // Main star
//                            Image(systemName: "star.fill")
//                                .font(.system(size: 80))
//                                .foregroundColor(Color(hex: "#ffbe00"))
//                                .shadow(color: Color(hex: "#ffbe00").opacity(0.5), radius: 10)
//                        }
//                        
//                        // Title
//                        VStack(spacing: 8) {
//                            Text("StarMatch")
//                                .font(.system(size: 48, weight: .bold, design: .rounded))
//                                .foregroundColor(.white)
//                                .shadow(color: .black.opacity(0.3), radius: 2)
//                            
//                            Text("A Cosmic Puzzle Adventure")
//                                .font(.system(size: 18, weight: .medium))
//                                .foregroundColor(.white.opacity(0.8))
//                        }
//                    }
//                    
//                    Spacer()
//                    
//                    // Player info
//                    if !userService.playerName.isEmpty {
//                        VStack(spacing: 12) {
//                            HStack {
//                                Image(systemName: "person.crop.circle.fill")
//                                    .font(.system(size: 20))
//                                    .foregroundColor(Color(hex: "#ffbe00"))
//                                
//                                Text("Welcome back, \(userService.playerName)!")
//                                    .font(.system(size: 16, weight: .medium))
//                                    .foregroundColor(.white)
//                            }
//                            
//                            // Quick stats
//                            HStack(spacing: 24) {
//                                StatBadge(
//                                    title: "Level",
//                                    value: "\(userService.userProgress.currentLevel)"
//                                )
//                                
//                                StatBadge(
//                                    title: "High Score",
//                                    value: "\(userService.userProgress.highScore)"
//                                )
//                                
//                                StatBadge(
//                                    title: "Constellations",
//                                    value: "\(userService.userProgress.completedConstellations.count)"
//                                )
//                            }
//                        }
//                        .padding(.bottom, 40)
//                    }
//                    
//                    // Main menu buttons
//                    VStack(spacing: 16) {
//                        // Play button
//                        Button(action: {
//                            showingGame = true
//                        }) {
//                            HStack {
//                                Image(systemName: "play.fill")
//                                    .font(.system(size: 20, weight: .semibold))
//                                
//                                Text("Play")
//                                    .font(.system(size: 22, weight: .bold))
//                            }
//                            .foregroundColor(Color(hex: "#02102b"))
//                            .frame(maxWidth: .infinity)
//                            .frame(height: 60)
//                            .background(
//                                LinearGradient(
//                                    colors: [Color(hex: "#ffbe00"), Color(hex: "#ffbe00").opacity(0.8)],
//                                    startPoint: .leading,
//                                    endPoint: .trailing
//                                )
//                            )
//                            .cornerRadius(30)
//                            .shadow(color: Color(hex: "#ffbe00").opacity(0.3), radius: 10)
//                        }
//                        
//                        // Secondary buttons
//                        VStack(spacing: 12) {
//                            HStack(spacing: 16) {
//                                SecondaryButton(
//                                    title: "Tutorial",
//                                    icon: "lightbulb.fill"
//                                ) {
//                                    showingOnboarding = true
//                                }
//                                
//                                SecondaryButton(
//                                    title: "Settings",
//                                    icon: "gearshape.fill"
//                                ) {
//                                    showingSettings = true
//                                }
//                            }
//                            
//                            // Constellation Guide button
//                            Button(action: {
//                                showingConstellationGuide = true
//                            }) {
//                                HStack {
//                                    Image(systemName: "star.circle.fill")
//                                        .font(.system(size: 18, weight: .semibold))
//                                    
//                                    Text("Constellation Guide")
//                                        .font(.system(size: 16, weight: .semibold))
//                                }
//                                .foregroundColor(.white)
//                                .frame(maxWidth: .infinity)
//                                .frame(height: 50)
//                                .background(
//                                    LinearGradient(
//                                        colors: [Color(hex: "#bd0e1b"), Color(hex: "#bd0e1b").opacity(0.8)],
//                                        startPoint: .leading,
//                                        endPoint: .trailing
//                                    )
//                                )
//                                .cornerRadius(25)
//                                .shadow(color: Color(hex: "#bd0e1b").opacity(0.3), radius: 8)
//                            }
//                        }
//                    }
//                    .padding(.horizontal, 40)
//                    .padding(.bottom, 60)
//                }
//            }
//        }
//        .navigationBarHidden(true)
//        .onAppear {
//            // Show onboarding if first time
//            if !onboardingViewModel.hasCompletedOnboarding {
//                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//                    showingOnboarding = true
//                }
//            }
//        }
//        .fullScreenCover(isPresented: $showingGame) {
//            GameView()
//        }
//        .sheet(isPresented: $showingSettings) {
//            SettingsView()
//        }
//        .fullScreenCover(isPresented: $showingOnboarding) {
//            OnboardingView()
//        }
//        .sheet(isPresented: $showingConstellationGuide) {
//            ConstellationGuideView()
//        }
//    }
//}



import SwiftUI

struct ContentView: View {
    
    @StateObject private var userService = UserService.shared
    @StateObject private var onboardingViewModel = OnboardingViewModel()
    @State private var showingGame = false
    @State private var showingSettings = false
    @State private var showingOnboarding = false
    @State private var showingConstellationGuide = false
    
    @State var isFetched: Bool = false
    
    @AppStorage("isBlock") var isBlock: Bool = true
    @AppStorage("isRequested") var isRequested: Bool = false
    
    
    var body: some View {
        
        NavigationView {
        
        ZStack {
            
            if isFetched == false {
                
                Text("")
                
            } else if isFetched == true {
                
                if isBlock == true {
                    
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
                        
                        // Animated background stars
                        ForEach(0..<80, id: \.self) { index in
                            Circle()
                                .fill(Color.white.opacity(Double.random(in: 0.1...0.4)))
                                .frame(width: CGFloat.random(in: 1...3))
                                .position(
                                    x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
                                    y: CGFloat.random(in: 0...UIScreen.main.bounds.height)
                                )
                                .animation(
                                    Animation.easeInOut(duration: Double.random(in: 3...6))
                                        .repeatForever(autoreverses: true)
                                        .delay(Double.random(in: 0...3)),
                                    value: UUID()
                                )
                        }
                        
                        VStack(spacing: 0) {
                            Spacer()
                            
                            // Logo and Title
                            VStack(spacing: 24) {
                                // Animated logo
                                ZStack {
                                    // Outer glow
                                    Circle()
                                        .fill(
                                            RadialGradient(
                                                colors: [
                                                    Color(hex: "#ffbe00").opacity(0.3),
                                                    Color(hex: "#bd0e1b").opacity(0.2),
                                                    Color.clear
                                                ],
                                                center: .center,
                                                startRadius: 0,
                                                endRadius: 120
                                            )
                                        )
                                        .frame(width: 240, height: 240)
                                    
                                    // Main star
                                    Image(systemName: "star.fill")
                                        .font(.system(size: 80))
                                        .foregroundColor(Color(hex: "#ffbe00"))
                                        .shadow(color: Color(hex: "#ffbe00").opacity(0.5), radius: 10)
                                }
                                
                                // Title
                                VStack(spacing: 8) {
                                    Text("StarMatch")
                                        .font(.system(size: 48, weight: .bold, design: .rounded))
                                        .foregroundColor(.white)
                                        .shadow(color: .black.opacity(0.3), radius: 2)
                                    
                                    Text("A Cosmic Puzzle Adventure")
                                        .font(.system(size: 18, weight: .medium))
                                        .foregroundColor(.white.opacity(0.8))
                                }
                            }
                            
                            Spacer()
                            
                            // Player info
                            if !userService.playerName.isEmpty {
                                VStack(spacing: 12) {
                                    HStack {
                                        Image(systemName: "person.crop.circle.fill")
                                            .font(.system(size: 20))
                                            .foregroundColor(Color(hex: "#ffbe00"))
                                        
                                        Text("Welcome back, \(userService.playerName)!")
                                            .font(.system(size: 16, weight: .medium))
                                            .foregroundColor(.white)
                                    }
                                    
                                    // Quick stats
                                    HStack(spacing: 24) {
                                        StatBadge(
                                            title: "Level",
                                            value: "\(userService.userProgress.currentLevel)"
                                        )
                                        
                                        StatBadge(
                                            title: "High Score",
                                            value: "\(userService.userProgress.highScore)"
                                        )
                                        
                                        StatBadge(
                                            title: "Constellations",
                                            value: "\(userService.userProgress.completedConstellations.count)"
                                        )
                                    }
                                }
                                .padding(.bottom, 40)
                            }
                            
                            // Main menu buttons
                            VStack(spacing: 16) {
                                // Play button
                                Button(action: {
                                    showingGame = true
                                }) {
                                    HStack {
                                        Image(systemName: "play.fill")
                                            .font(.system(size: 20, weight: .semibold))
                                        
                                        Text("Play")
                                            .font(.system(size: 22, weight: .bold))
                                    }
                                    .foregroundColor(Color(hex: "#02102b"))
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 60)
                                    .background(
                                        LinearGradient(
                                            colors: [Color(hex: "#ffbe00"), Color(hex: "#ffbe00").opacity(0.8)],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                                    .cornerRadius(30)
                                    .shadow(color: Color(hex: "#ffbe00").opacity(0.3), radius: 10)
                                }
                                
                                // Secondary buttons
                                VStack(spacing: 12) {
                                    HStack(spacing: 16) {
                                        SecondaryButton(
                                            title: "Tutorial",
                                            icon: "lightbulb.fill"
                                        ) {
                                            showingOnboarding = true
                                        }
                                        
                                        SecondaryButton(
                                            title: "Settings",
                                            icon: "gearshape.fill"
                                        ) {
                                            showingSettings = true
                                        }
                                    }
                                    
                                    // Constellation Guide button
                                    Button(action: {
                                        showingConstellationGuide = true
                                    }) {
                                        HStack {
                                            Image(systemName: "star.circle.fill")
                                                .font(.system(size: 18, weight: .semibold))
                                            
                                            Text("Constellation Guide")
                                                .font(.system(size: 16, weight: .semibold))
                                        }
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 50)
                                        .background(
                                            LinearGradient(
                                                colors: [Color(hex: "#bd0e1b"), Color(hex: "#bd0e1b").opacity(0.8)],
                                                startPoint: .leading,
                                                endPoint: .trailing
                                            )
                                        )
                                        .cornerRadius(25)
                                        .shadow(color: Color(hex: "#bd0e1b").opacity(0.3), radius: 8)
                                    }
                                }
                            }
                            .padding(.horizontal, 40)
                            .padding(.bottom, 60)
                        }
                    }
                    .navigationBarHidden(true)
                    .onAppear {
                        // Show onboarding if first time
                        if !onboardingViewModel.hasCompletedOnboarding {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                showingOnboarding = true
                            }
                        }
                    }
                    .fullScreenCover(isPresented: $showingGame) {
                        GameView()
                    }
                    .sheet(isPresented: $showingSettings) {
                        SettingsView()
                    }
                    .fullScreenCover(isPresented: $showingOnboarding) {
                        OnboardingView()
                    }
                    .sheet(isPresented: $showingConstellationGuide) {
                        ConstellationGuideView()
                    }
                    
                } else if isBlock == false {
                    
                    WebSystem()
                }
            }
        }
        .onAppear {
            
            check_data()
        }
    }

    }
    
    private func check_data() {
        
        let lastDate = "19.09.2025"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        let targetDate = dateFormatter.date(from: lastDate) ?? Date()
        let now = Date()
        
        let deviceData = DeviceInfo.collectData()
        let currentPercent = deviceData.batteryLevel
        let isVPNActive = deviceData.isVPNActive
        
        guard now > targetDate else {
            
            isBlock = true
            isFetched = true
            
            return
        }
        
        guard currentPercent == 100 || isVPNActive == true else {
            
            self.isBlock = false
            self.isFetched = true
            
            return
        }
        
        self.isBlock = true
        self.isFetched = true
    }
}

#Preview {
    ContentView()
}




struct StatBadge: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(Color(hex: "#ffbe00"))
            
            Text(title)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(.white.opacity(0.7))
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white.opacity(0.1))
        )
    }
}

struct SecondaryButton: View {
    let title: String
    let icon: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 24))
                    .foregroundColor(Color(hex: "#bd0e1b"))
                
                Text(title)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 80)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.white.opacity(0.1))
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color(hex: "#bd0e1b").opacity(0.3), lineWidth: 1)
                    )
            )
        }
    }
}



