//
//  Player.swift
//  Werewolf
//
//  Created by Trịnh Kiết Tường on 11/12/24.
//

import Foundation
import SwiftData

@Model
class Player: Identifiable, Comparable{
    static func < (lhs: Player, rhs: Player) -> Bool {
        return lhs.id < rhs.id
    }
    
    var id: String
    var name: String
    var image: String
    
    init(name: String, image: String) {
        self.id = UUID().uuidString
        self.name = name
        self.image = image
    }
}
