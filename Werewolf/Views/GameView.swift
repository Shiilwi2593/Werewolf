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
    @State private var timeElapsed: Int = 0
    @State private var timer: Timer.TimerPublisher?
    @State private var timerSubscription: Cancellable?
    @State private var isGridMode: Bool = false // New state to toggle layout

    var body: some View {
        NavigationView {
            ZStack {
                Image(isNightMode ? "dark" : "light")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .ignoresSafeArea()
                    .transition(.opacity)
                    .animation(.easeInOut(duration: 0.5), value: isNightMode)

                VStack {
                    HStack {
                        Image(systemName: isNightMode ? "moon.zzz.fill" : "sun.max.fill")
                            .font(.title)
                            .foregroundColor(isNightMode ? .purple : .yellow)

                        Toggle("", isOn: $isNightMode)
                            .labelsHidden()
                            .toggleStyle(SwitchToggleStyle(tint: .pink))
                    }
                    .padding()

                    // Toggle layout button
                    Button(action: {
                        withAnimation {
                            isGridMode.toggle()
                        }
                    }) {
                        Text(isGridMode ? "Switch to Picker" : "Switch to Grid")
                            .font(.headline)
                            .padding()
                            .background(Capsule().fill(isNightMode ? Color.teal : Color.yellow))
                            .foregroundColor(.white)
                    }
                    .padding(.bottom)

                    if isGridMode {
                        // Grid Layout
                        ScrollView {
                            VStack{
                                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 10), count: 3), spacing: 15) {
                                    ForEach(players.indices, id: \.self) { index in
                                        PlayerCard(player: players[index])
                                            .onTapGesture {
                                                selectedPlayerIndex = index
                                                showRoleSheet = true
                                            }
                                    }
                                }
                                Text(timeFormatted(timeElapsed))
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(.black)
                                    .padding(.top, 10)
                            }
                          
                            
                        }
                        .padding()

                    } else {
                        // Horizontal Picker
                        HStack {
                            Button(action: {
                                withAnimation {
                                    if selectedPlayerIndex > 0 {
                                        selectedPlayerIndex -= 1
                                    }
                                }
                            }) {
                                Image(systemName: "arrow.left")
                                    .font(.largeTitle)
                                    .foregroundColor(selectedPlayerIndex > 0 ? .blue : .gray)
                            }
                            .disabled(selectedPlayerIndex == 0)

                            Spacer()

                            VStack(spacing: 10) {
                                Circle()
                                    .foregroundStyle(.purple)
                                    .frame(width: 165, height: 165)
                                    .shadow(radius: 10)
                                    .overlay {
                                        Image(players[selectedPlayerIndex].image)
                                            .resizable()
                                            .frame(width: 150, height: 150)
                                            .clipShape(Circle())
                                            .onTapGesture {
                                                showRoleSheet = true
                                            }
                                    }

                                Text(players[selectedPlayerIndex].name)
                                    .font(.system(size: 22))
                                    .fontWeight(.bold)
                                    .foregroundStyle(isNightMode ? .white : .black)

                                if !isNightMode { // Show timer during daytime
                                    Text(timeFormatted(timeElapsed))
                                        .font(.title)
                                        .fontWeight(.bold)
                                        .foregroundColor(.black)
                                        .padding(.top, 10)
                                }
                            }

                            Spacer()

                            Button(action: {
                                withAnimation {
                                    if selectedPlayerIndex < players.count - 1 {
                                        selectedPlayerIndex += 1
                                    }
                                }
                            }) {
                                Image(systemName: "arrow.right")
                                    .font(.largeTitle)
                                    .foregroundColor(selectedPlayerIndex < players.count - 1 ? .blue : .gray)
                            }
                            .disabled(selectedPlayerIndex == players.count - 1)
                        }
                        .padding()
                    }

                    Button(action: {
                        resetTimer() // Reset timer button
                    }) {
                        Text("Reset Time")
                            .font(.title2)
                            .padding()
                            .background(Capsule().fill(isNightMode ? Color.teal : Color.yellow))
                            .foregroundColor(.white)
                    }
                    .padding()

                    Spacer()
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
                }
            }
            .navigationBarHidden(true)
        }
    }

    // Helper Functions
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
            let audios = ["soundtrack1", "soundtrack2", "soundtrack4", "soundtrack5"]
            let randomAudio = audios.randomElement() ?? "soundtrack1"
            AudioManager.shared.playSound(named: randomAudio)
        } else {
            AudioManager.shared.playSound(named: "daysoundtrack")
        }
    }
}

// Subview for Player Card in Grid
struct PlayerCard: View {
    let player: Player

    var body: some View {
        VStack {
            Image(player.image)
                .resizable()
                .frame(width: 75, height: 75)
                .clipShape(Circle())

            Text(player.name)
                .font(.caption)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(.black.opacity(0.6))
                .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 3)
        )
    }
}

// Subview for Role Detail Sheet
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
