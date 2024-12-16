//
//  AdjustRoleView.swift
//  Werewolf
//
//  Created by Trịnh Kiết Tường on 12/12/24.
//

import SwiftUI
import SwiftData

struct AdjustRoleView: View {
    var players: [Player]
    @State private var playerCount = 0
    @State private var roleCounts: [Role: Int] = [:]
    @State private var isReady: Bool = false
    @State private var roleAssignments: [Player: Role] = [:]
    
    
    @Environment(\.modelContext) private var context
    @Query private var roles: [Role]
    
    var body: some View {
        VStack {
            ScrollView {
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: 15) {
                    ForEach(roles) { role in
                        VStack {
                            Image(role.image)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 100, height: 100)
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                            
                            Text(role.roleName)
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundStyle(.black)
                            
                            Text(role.roleDes)
                                .font(.caption)
                                .foregroundColor(.gray)
                                .lineLimit(2)
                                .multilineTextAlignment(.center)
                            
                            HStack {
                                Button(action: {
                                    if roleCounts[role] ?? 0 > 0 {
                                        roleCounts[role] = (roleCounts[role] ?? 0) - 1
                                    }
                                    checkReady()
                                }) {
                                    Image(systemName: "minus.circle")
                                        .font(.title2)
                                        .foregroundStyle(Color.indigo)
                                }
                                Text("\(roleCounts[role] ?? 0)")
                                    .font(.title2)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(.black)
                                
                                Button(action: {
                                    if (roleCounts.values.reduce(0, +)) < playerCount {
                                        roleCounts[role] = (roleCounts[role] ?? 0) + 1
                                    }
                                    checkReady()
                                }) {
                                    Image(systemName: "plus.circle")
                                        .font(.title2)
                                        .foregroundStyle(Color.indigo)
                                }
                            }
                            .padding(.top, 10)
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Color.white)
                                .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 3)
                        )
                    }
                }
                .padding()
            }
            
            Text("Total Roles: \(roleCounts.values.reduce(0, +)) / \(playerCount)")
                .font(.footnote)
                .foregroundColor(.secondary)
                .padding()
        }
        .onAppear(){
            
        }
        .toolbar{
            ToolbarItem(placement: .topBarTrailing) {
                if isReady{
                    NavigationLink(destination: GameView(players: players, roleAssignments: assignRoles())) {
                        Image(systemName: "arrow.forward.square.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .foregroundStyle(.teal)
                            .frame(width: 35, height: 35)
                    }
                    
                }
            }
            
        }
        .onAppear {
            for player in players{
                print(player.name)
            }
            playerCount = players.count
            roleCounts = Dictionary(uniqueKeysWithValues: roles.map { ($0, 0) })
            checkReady()
        }
        
    }
    
    func checkReady() {
        isReady = roleCounts.values.reduce(0, +) == playerCount
    }
    
    func assignRoles() -> [Player: Role] {
        var assignments: [Player: Role] = [:]
        var playerIndex = 0
        let shuffledRoles = roleCounts.shuffled()
        for (role, count) in shuffledRoles {
            if count > 0 {
                for _ in 1...count {
                    if playerIndex < players.count {
                        assignments[players[playerIndex]] = role
                        playerIndex += 1
                    } else {
                        break
                    }
                }
            }
        }
        return assignments
    }
}

