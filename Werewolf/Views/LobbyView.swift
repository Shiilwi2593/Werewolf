//
//  LobbyView.swift
//  Werewolf
//
//  Created by Trịnh Kiết Tường on 11/12/24.
//

import SwiftUI
import SwiftData

struct LobbyView: View {
    let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    @Query private var players: [Player]
    @State private var playerList: [Player] = []
    @Environment(\.colorScheme) private var colorScheme
    
    // Compute top winner
    private var topWinner: Player? {
        playerList.max(by: { $0.gameWin < $1.gameWin })
    }
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            // Background
            Color(colorScheme == .dark ? .black : .gray.opacity(0.05))
                .ignoresSafeArea()
            
            // Main Content
            VStack(spacing: 0) {
                List {
                    ForEach(playerList) { player in
                        let isTopWinner = player.id == topWinner?.id
                        
                        HStack(spacing: 16) {
                            // Player Image with Crown
                            ZStack(alignment: .topTrailing) {
                                Circle()
                                    .fill(Color.purple.opacity(colorScheme == .dark ? 0.2 : 0.1))
                                    .frame(width: 70, height: 70)
                                    .overlay {
                                        Image(player.image)
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: 60, height: 60)
                                            .clipShape(Circle())
                                    }
                                
                                // Crown for top winner
                                if isTopWinner {
                                    Image(systemName: "crown.fill")
                                        .foregroundStyle(.yellow)
                                        .font(.system(size: 16))
                                        .background(
                                            Circle()
                                                .fill(colorScheme == .dark ? Color(.systemGray6) : .white)
                                                .frame(width: 24, height: 24)
                                        )
                                        .offset(x: 5, y: -5)
                                }
                            }
                            .shadow(color: colorScheme == .dark ? .clear : .black.opacity(0.1),
                                   radius: 3, x: 0, y: 2)
                            
                            // Player Info
                            VStack(alignment: .leading, spacing: 4) {
                                Text(player.name)
                                    .font(.headline)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(colorScheme == .dark ? .white : .primary)
                                
                                HStack(spacing: 4) {
                                    Image(systemName: "trophy.fill")
                                        .foregroundStyle(.yellow)
                                        .font(.caption)
                                    Text("\(player.gameWin) wins")
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                }
                            }
                            
                            Spacer()
                            
                            // Reorder Handle
                            Image(systemName: "line.3.horizontal")
                                .foregroundStyle(.gray)
                                .font(.title3)
                        }
                        .padding(.vertical, 8)
                        .listRowBackground(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(colorScheme == .dark ? Color(.systemGray6) : .white)
                                .shadow(
                                    color: colorScheme == .dark ? .clear : .black.opacity(0.05),
                                    radius: isTopWinner ? 4 : 2,
                                    x: 0,
                                    y: 1
                                )
                                .padding(.vertical, 4)
                        )
                        .listRowSeparator(.hidden)
                    }
                    .onMove { indices, newOffset in
                        playerList.move(fromOffsets: indices, toOffset: newOffset)
                    }
                }
                .listStyle(.plain)
                .padding(.horizontal, -8)
                .scrollContentBackground(colorScheme == .dark ? .hidden : .visible)
            }
            .navigationTitle("Sắp xếp người chơi")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    EditButton()
                        .font(.headline)
                }
            }
            
            // Next Button
            NavigationLink(destination: AdjustRoleView(players: playerList)) {
                HStack(spacing: 8) {
                    Text("Next")
                        .font(.headline)
                    Image(systemName: "arrow.right")
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
                .background(
                    Capsule()
                        .fill(Color.yellow)
                        .shadow(
                            color: colorScheme == .dark ? .clear : .black.opacity(0.15),
                            radius: 4,
                            x: 0,
                            y: 2
                        )
                )
                .foregroundColor(colorScheme == .dark ? .black : .white)
            }
            .padding(.bottom, 30)
            .padding(.trailing, 20)
        }
        .onAppear {
            playerList = players
        }
    }
}

