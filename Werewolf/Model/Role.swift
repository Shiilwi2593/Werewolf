//
//  Role.swift
//  Werewolf
//
//  Created by Trịnh Kiết Tường on 11/12/24.
//
import Foundation
import SwiftData

@Model
class Role: Identifiable{
    var id: String
    var roleName: String
    var image: String
    var roleDes: String
    var roleType: RoleType
    
    enum RoleType: String, Codable{
        case Good
        case Bad
        case Neutral
    }
    
    init(roleName: String,image: String, roleDes: String, roleType: RoleType) {
        self.id = UUID().uuidString
        self.roleName = roleName
        self.image = image
        self.roleDes = roleDes
        self.roleType = roleType
    }
}
