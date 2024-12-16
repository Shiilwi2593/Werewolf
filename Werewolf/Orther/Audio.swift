//
//  Audio.swift
//  Werewolf
//
//  Created by Trịnh Kiết Tường on 12/12/24.
//
import Foundation
import AVFoundation

class AudioManager: ObservableObject {
    static let shared = AudioManager() // Singleton instance
    private var player: AVAudioPlayer?

    private init() {} // Đảm bảo không thể khởi tạo từ bên ngoài

    func playSound(named fileName: String, fileType: String = "mp3") {
        guard let url = Bundle.main.url(forResource: fileName, withExtension: fileType) else {
            print("File not found: \(fileName).\(fileType)")
            return
        }
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.play()
        } catch {
            print("Error playing sound: \(error.localizedDescription)")
        }
    }

    func stopSound() {
        player?.stop()
    }

    func isPlaying() -> Bool {
        return player?.isPlaying ?? false
    }
}
