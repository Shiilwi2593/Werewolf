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
    
    var body: some View {
        ZStack(alignment: .bottomTrailing){
            
            NavigationLink(destination: AdjustRoleView(players: playerList)) {
                Image(systemName: "arrow.right.circle.fill")
                    .resizable()
                    .foregroundStyle(.yellow.opacity(0.8))
                    .frame(width: 50, height: 50)
                    .padding(.bottom, 30)
                    .padding(.trailing, 15)
            }
            .zIndex(1)

            
            VStack {
                List {
                    ForEach(playerList) { player in
                        HStack {
                            Circle()
                                .frame(width: 70, height: 70)
                                .foregroundStyle(.purple.opacity(0.8))
                                .overlay {
                                    Image(player.image)
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 60, height: 60)
                                        .clipShape(Circle())
                                }
                            Text(player.name)
                                .font(.footnote)
                        }
                    }
                    .onMove { indices, newOffset in
                        playerList.move(fromOffsets: indices, toOffset: newOffset)
                        for player in playerList{
                            print(player.name)
                        }
                    }
                }
                .navigationTitle("Sắp xếp người chơi")
                .navigationBarTitleDisplayMode(.inline)
                .onAppear {
                    playerList = players
                }
                .toolbar {
                    EditButton()
                }
            }
            .zIndex(0)
             
        }
    }
}

#Preview {
    LobbyView()
}
