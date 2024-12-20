//
//  GameView.swift
//  Werewolf
//
//  Created by Trịnh Kiết Tường on 12/12/24.
//

import SwiftUI
import Combine

struct GameView: View {
    var players: [Player]
    var roleAssignments: [Player: Role]
    
    @State private var selectedPlayerIndex: Int = 0
    @State private var showRoleSheet: Bool = false
    @State private var isNightMode: Bool = false
    @State private var isGridView: Bool = false
    @State private var timeElapsed: Int = 0
    @State private var timer: Timer.TimerPublisher?
    @State private var timerSubscription: Cancellable?
    
    var dayColors: [Color] = [
        Color.blue.opacity(0.5),
        Color.white,
        Color.yellow.opacity(0.3)
    ]
    
    var nightColors: [Color] = [
        Color.black,
        Color.purple.opacity(0.8),
        Color.indigo
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: isNightMode ? nightColors : dayColors),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                .animation(.easeInOut(duration: 0.5), value: isNightMode)
                
                VStack(spacing: 20) {
                    HStack {
                        Image(systemName: "sun.max.fill")
                            .foregroundColor(isNightMode ? .gray : .yellow)
                        
                        Toggle("", isOn: $isNightMode)
                            .labelsHidden()
                            .toggleStyle(CustomToggleStyle())
                        
                        Image(systemName: "moon.zzz.fill")
                            .foregroundColor(isNightMode ? .purple : .gray)
                    }
                    .padding()
                    .background(
                        Capsule()
                            .fill(Color.black.opacity(0.1))
                    )
                    
                    ZStack {
                        Circle()
                            .stroke(isNightMode ? Color.teal.opacity(0.3) : Color.yellow.opacity(0.3), lineWidth: 15)
                            .frame(width: 120, height: 120)
                        
                        Circle()
                            .trim(from: 0, to: min(CGFloat(timeElapsed) / 3600, 1.0))
                            .stroke(
                                isNightMode ? Color.teal : Color.yellow,
                                style: StrokeStyle(lineWidth: 15, lineCap: .round)
                            )
                            .frame(width: 120, height: 120)
                            .rotationEffect(.degrees(-90))
                        
                        Text(timeFormatted(timeElapsed))
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(isNightMode ? .white : .black)
                    }
                    .padding()
                    
                    if isGridView {
                        ScrollView{
                            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 10), count: 3), spacing: 20) {
                                ForEach(players.indices, id: \.self) { index in
                                    VStack {
                                        VStack {
                                            Circle()
                                                .frame(width: 100, height: 100)
                                                .foregroundColor(.gray)
                                                .overlay(
                                                    Image(players[index].image)
                                                        .resizable()
                                                        .scaledToFill()
                                                        .frame(width: 90, height: 90)
                                                        .clipShape(Circle())
                                                )
                                                .shadow(radius: 5)

                                            Text(players[index].name)
                                                .font(.subheadline)
                                                .fontWeight(.bold)
                                                .foregroundColor(.white)
                                                .padding(.top, 5)
                                        }
                                        .onTapGesture {
                                            selectedPlayerIndex = index
                                            showRoleSheet = true
                                        }
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                        .frame(height: 300)
                       
                    } else {
                        HStack {
                            Button(action: {
                                if selectedPlayerIndex > 0 {
                                    withAnimation(.easeInOut(duration: 0.3)) {
                                        selectedPlayerIndex -= 1
                                    }
                                }
                            }) {
                                Image(systemName: "arrow.left.circle.fill")
                                    .font(.largeTitle)
                                    .foregroundColor(.white)
                            }

                            PlayerCarouselItem(
                                player: players[selectedPlayerIndex],
                                isSelected: true,
                                onTap: {
                                    withAnimation(.easeInOut(duration: 0.3)) {
                                        showRoleSheet = true
                                    }
                                }
                            )
                            .frame(width: 200, height: 200)
                            .scaleEffect(1.0)
                            .transition(.slide)

                            Button(action: {
                                if selectedPlayerIndex < players.count - 1 {
                                    withAnimation(.easeInOut(duration: 0.3)) {
                                        selectedPlayerIndex += 1
                                    }
                                }
                            }) {
                                Image(systemName: "arrow.right.circle.fill")
                                    .font(.largeTitle)
                                    .foregroundColor(.white)
                            }
                        }
                        .padding()
                    }
                    
                    HStack(spacing: 20) {
                        ActionButton(
                            title: "Reset Time",
                            backgroundColor: isNightMode ? Color.teal : Color.yellow,
                            action: resetTimer
                        )
                        
                        ActionButton(
                            title: isGridView ? "Switch to Picker" : "Switch to Grid",
                            backgroundColor: isNightMode ? Color.purple : Color.orange,
                            action: {
                                withAnimation(.easeInOut) {
                                    isGridView.toggle()
                                }
                            }
                        )
                    }
                    .padding()
                }
            }
            .onAppear {
                startTimer()
                configureAudio(isNight: isNightMode)
            }
            .onChange(of: isNightMode) { _, newValue in
                configureAudio(isNight: newValue)
            }
            .sheet(isPresented: $showRoleSheet) {
                if let role = roleAssignments[players[selectedPlayerIndex]] {
                    RoleDetailSheet(role: role)
                        .presentationDetents([.medium, .medium])
                }
            }
            .navigationBarHidden(true)
        }
    }
    
    func startTimer() {
        timer = Timer.publish(every: 1, on: .main, in: .common)
        timerSubscription = timer?.autoconnect().sink { _ in
            timeElapsed += 1
        }
    }
    
    func resetTimer() {
        timeElapsed = 0
    }
    
    func timeFormatted(_ totalSeconds: Int) -> String {
        let minutes = (totalSeconds % 3600) / 60
        let seconds = totalSeconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    func configureAudio(isNight: Bool) {
        AudioManager.shared.stopSound()
        if isNight {
            let audios = ["soundtrack1", "soundtrack2", "soundtrack4", "soundtrack5","soundtrack6", "soundtrack7", "soundtrack8", "soundtrack9","soundtrack10", "soundtrack11", "soundtrack12", "soundtrack13"]
            let randomAudio = audios.randomElement() ?? "soundtrack1"
            AudioManager.shared.playSound(named: randomAudio)
        } else {
            AudioManager.shared.playSound(named: "daysoundtrack")
        }
    }
}


struct PlayerCarouselView: View {
    @State private var selectedPlayerIndex: Int = 0
    @State private var showRoleSheet: Bool = false
    
    let players: [Player] // Assume Player is a defined model
    
    var body: some View {
        VStack {
            HStack {
                // Left Arrow with Animation
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        if selectedPlayerIndex > 0 {
                            selectedPlayerIndex -= 1
                        }
                    }
                }) {
                    Image(systemName: "arrow.left.circle.fill")
                        .font(.largeTitle)
                        .foregroundColor(.white)
                }
                
                // Player Carousel Item with Slide Transition
                PlayerCarouselItem(
                    player: players[selectedPlayerIndex],
                    isSelected: true,
                    onTap: {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            showRoleSheet = true
                        }
                    }
                )
                .frame(width: 200, height: 200)
                .transition(.slide)
                
                // Right Arrow with Animation
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        if selectedPlayerIndex < players.count - 1 {
                            selectedPlayerIndex += 1
                        }
                    }
                }) {
                    Image(systemName: "arrow.right.circle.fill")
                        .font(.largeTitle)
                        .foregroundColor(.white)
                }
            }
            .padding()
            .animation(.easeInOut(duration: 0.3), value: selectedPlayerIndex)
        }
    }
}


struct PlayerCarouselItem: View {
    let player: Player
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        VStack {
            ZStack {
                Circle()
                    .frame(width: 120, height: 120) // Smaller size for grid items
                    .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
                    .background(
                        isSelected
                        ? LinearGradient(
                            gradient: Gradient(colors: [.purple, .blue]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                        : LinearGradient(
                            gradient: Gradient(colors: [.gray, .gray]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .clipShape(Circle())
                
                Image(player.image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 110, height: 110) // Smaller size for grid items
                    .clipShape(Circle())
                    .overlay(
                        Circle()
                            .stroke(isSelected ? Color.white : Color.clear, lineWidth: 4)
                    )
                    .onTapGesture(perform: onTap)
            }
            
            Text(player.name)
                .font(.headline)
                .foregroundColor(isSelected ? .white : .secondary)
                .padding(.top, 8)
        }
        .padding()
    }
}

// Reusable Action Button
struct ActionButton: View {
    let title: String
    let backgroundColor: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.headline)
                .padding()
                .background(
                    Capsule()
                        .fill(backgroundColor)
                )
                .foregroundColor(.white)
                .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 3)
        }
    }
}

// Custom Toggle Style
struct CustomToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        ZStack {
            Capsule()
                .fill(configuration.isOn ? Color.purple.opacity(0.3) : Color.gray.opacity(0.3))
                .frame(width: 50, height: 30)
            
            Circle()
                .fill(configuration.isOn ? Color.purple : Color.gray)
                .frame(width: 26, height: 26)
                .offset(x: configuration.isOn ? 10 : -10)
        }
        .onTapGesture {
            configuration.isOn.toggle()
        }
    }
}

struct RoleDetailSheet: View {
    let role: Role
    
    var body: some View {
        VStack {
            Image(role.image)
                .resizable()
                .frame(width: 150, height: 150)
                .clipShape(RoundedRectangle(cornerRadius: 20))
            
            Text(role.roleName)
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top, 10)
            
            Text(role.roleDes)
                .font(.body)
                .padding()
        }
        .padding()
    }
}
