//
//  WerewolfApp.swift
//  Werewolf
//
//  Created by Trịnh Kiết Tường on 11/12/24.
//

import AVFoundation

import SwiftUI
import SwiftData
@main
struct WerewolfApp: App {
    var body: some Scene {
        WindowGroup {
            MainView()
                .ignoresSafeArea()
        }
        .modelContainer(for: [Player.self, Role.self])
    }
}
