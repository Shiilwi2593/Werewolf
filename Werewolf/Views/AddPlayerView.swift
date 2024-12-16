//
//  AddPlayerView.swift
//  Werewolf
//
//  Created by Trịnh Kiết Tường on 11/12/24.
//
import SwiftUI

struct AddPlayerView: View {
    @State private var playerName: String = ""
    @State private var selectedImage: String = "person1" // Default image

    @Environment(\.modelContext) private var modelContext // Assuming SwiftData is set up properly

    private let availableImages = ["person1", "person2", "person3", "person4", "person5", "person6", "person7","person8", "person9", "person10", "person11", "person12", "person13","person14", "person15", "person16", "person17", "person18", "person19","person20", "person21", "person22", "person23", "person24", "person25", "person26","person27","person28","person29"]

    var body: some View {
        VStack(spacing: 20) {
            Text("Add New Player")
                .font(.headline)

            // TextField to enter player's name
            TextField("Enter player's name", text: $playerName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            // Display selected image
            Image(selectedImage)
                .resizable()
                .scaledToFill()
                .frame(width: 130, height: 130)
                .cornerRadius(10)
            

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    ForEach(availableImages, id: \.self) { imageName in
                        Image(imageName)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                            .overlay(
                                Circle()
                                    .stroke(selectedImage == imageName ? Color.blue : Color.clear, lineWidth: 3)
                            )
                            .onTapGesture {
                                selectedImage = imageName
                            }
                    }
                }
                .padding()
            }

            Button(action: {
                addPlayer()
            }) {
                Text("Add Player")
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding(.horizontal)
            .disabled(playerName.isEmpty)
        }
        .padding()
    }

    private func addPlayer() {
        let newPlayer = Player(name: playerName, image: selectedImage)
        modelContext.insert(newPlayer)
        print("Player \(playerName) added with image \(selectedImage)")
        resetForm()
    }

    // Reset form after adding a player
    private func resetForm() {
        playerName = ""
        selectedImage = "person1"
    }
}

#Preview {
    AddPlayerView()
}
