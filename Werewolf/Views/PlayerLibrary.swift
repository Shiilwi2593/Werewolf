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

    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(players) { player in
                    VStack {
                        HStack {
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

                            Text(player.name)
                                .font(.subheadline)
                                .fontWeight(.semibold)
                            Spacer()


                            Button {
                                deletePlayer(player)
                            } label: {
                                Image(systemName: "trash")
                                    .foregroundColor(.red)
                            }
                        }
                        Spacer()
                            .frame(height: 20)
                    }
                }
            }
            .padding()
            Spacer()
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    print("add")
                } label: {
                    NavigationLink(destination: AddPlayerView()) {
                        Image(systemName: "plus")
                    }
                }
            }
        }
        .navigationTitle("Thư viện người chơi")
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - Functions

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
