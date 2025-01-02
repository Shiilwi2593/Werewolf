//
//  PlayerLibrary.swift
//  Werewolf
//
//  Created by Trịnh Kiết Tường on 11/12/24.
//

import SwiftUI
import SwiftData

struct PlayerLibrary: View {
    @Environment(\.modelContext) private var context
    @Query var players: [Player]
    
    @State private var editingPlayer: Player?
    @State private var showEditAlert: Bool = false
    
    // Tính toán người chơi có số win cao nhất
    private var topPlayer: Player? {
        players.max(by: { $0.gameWin < $1.gameWin })
    }
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(players) { player in
                    let isTopPlayer = player.id == topPlayer?.id
                    
                    HStack(spacing: 16) {
                        // Player Image
                        Circle()
                            .foregroundStyle(.gray)
                            .frame(width: 70, height: 70)
                            .overlay {
                                Image(player.image)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 60, height: 60)
                                    .clipShape(Circle())
                            }
                            .overlay(alignment: .topTrailing) {
                                // Crown badge for top player
                                if isTopPlayer {
                                    Image(systemName: "crown.fill")
                                        .foregroundStyle(Color.cyan)
                                        .background(
                                            Circle()
                                                .fill(.white)
                                                .frame(width: 24, height: 24)
                                        )
                                        .offset(x: 5, y: -5)
                                }
                            }
                            .shadow(radius: 2)
                        
                        // Player Name
                        Text(player.name)
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundStyle(.black)
                        
                        Spacer()
                        
                        // Win Statistics
                        VStack(alignment: .trailing, spacing: 4) {
                            HStack(spacing: 4) {
                                Image(systemName: "trophy.fill")
                                    .foregroundStyle(.yellow)
                                Text("\(player.gameWin)")
                                    .font(.title3)
                                    .fontWeight(.bold)
                                    .foregroundStyle(.black)
                            }
                            Text("wins")
                                .font(.caption)
                                .foregroundStyle(.black)
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.gray.opacity(0.1))
                        )
                        
                        // Delete Button
                        Button {
                            deletePlayer(player)
                        } label: {
                            Image(systemName: "trash")
                                .foregroundColor(.red)
                                .padding(8)
                                .background(
                                    Circle()
                                        .fill(Color.red.opacity(0.1))
                                )
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(isTopPlayer ? Color.yellow.opacity(0.7) : Color.white)
                            .shadow(color: isTopPlayer ? Color.yellow.opacity(0.7) : .black.opacity(0.05),
                                   radius: isTopPlayer ? 8 : 5,
                                   x: 0,
                                   y: 2)
                    )
                    .padding(.horizontal)
                }
            }
            .padding(.vertical)
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink(destination: AddPlayerView()) {
                    Image(systemName: "plus")
                        .fontWeight(.semibold)
                }
            }
        }
        .navigationTitle("Thư viện người chơi")
        .navigationBarTitleDisplayMode(.inline)
        .background(Color.gray.opacity(0.05))
    }
    
    private func deletePlayer(_ player: Player) {
        context.delete(player)
        do {
            try context.save()
        } catch {
            print("Error deleting player: \(error)")
        }
    }
}

#Preview {
    PlayerLibrary()
}
