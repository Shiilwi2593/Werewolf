//
//  MainView.swift
//  Werewolf
//
//  Created by Trịnh Kiết Tường on 11/12/24.
//

import SwiftUI
import SwiftData

struct MainView: View {
    
    @State private var isFetch: Bool = false
    @Query private var roles: [Role]
    let mainVwVM = MainVwViewModel()
    private var audioManager = AudioManager.shared
    @State private var isPlaying:Bool = false
    
    
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        NavigationStack{
            ZStack {
                Image("werewolfBackground")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .ignoresSafeArea()
                
                VStack(spacing: 30) {
                    Button(action: {
                        print("Bắt đầu game")
                    }) {
                        NavigationLink(destination: LobbyView()) {
                            ZStack {
                                LinearGradient(
                                    gradient: Gradient(colors: [Color.blue, Color.purple]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                                .frame(width: 300, height: 60)
                                .cornerRadius(15)
                                .shadow(color: Color.purple.opacity(0.5), radius: 10, x: 0, y: 5)
                                
                                Text("Bắt đầu game")
                                    .foregroundColor(.white)
                                    .font(.system(size: 20, weight: .bold, design: .rounded))
                            }
                            
                        }
                    }
                    .buttonStyle(.plain)
                    
                    Button(action: {
                        print("player library")
                    }) {
                        NavigationLink(destination: PlayerLibrary()) {
                            ZStack {
                                LinearGradient(
                                    gradient: Gradient(colors: [Color.green, Color.teal]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                                .frame(width: 300, height: 60)
                                .cornerRadius(15)
                                .shadow(color: Color.teal.opacity(0.5), radius: 10, x: 0, y: 5)
                                
                                Text("Thư viện người chơi")
                                    .foregroundColor(.white)
                                    .font(.system(size: 20, weight: .bold, design: .rounded))
                            }
                            
                        }
                    }
                    .buttonStyle(.plain)
                    
                    Button(action: {
                        print("Danh sách vai trò")
                    }) {
                        NavigationLink(destination: RoleLibrary()) {
                            ZStack {
                                LinearGradient(
                                    gradient: Gradient(colors: [Color.orange, Color.red]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                                .frame(width: 300, height: 60)
                                .cornerRadius(15)
                                .shadow(color: Color.red.opacity(0.5), radius: 10, x: 0, y: 5)
                                
                                Text("Thư viện vai trò")
                                    .foregroundColor(.white)
                                    .font(.system(size: 20, weight: .bold, design: .rounded))
                            }
                            
                        }
                    }
                    .buttonStyle(.plain)
                }
            }
            .onAppear {
                if roles.isEmpty {
                    addDefaultRole()
                    isFetch = true
                }
                
                if !isPlaying {
                    let audionames = ["soundtrack1", "soundtrack2", "soundtrack3", "soundtrack4", "soundtrack5", "soundtrack6", "soundtrack7", "soundtrack8", "soundtrack9", "soundtrack10", "soundtrack11", "soundtrack12,soundtrack13"]
                    let randomAudio = audionames.randomElement() ?? "soundtrack1"
                    audioManager.playSound(named: randomAudio)
                    isPlaying = true
                }
                
            }
            
        }
    }
    
    
    func addDefaultRole(){
        let roles: [Role] = [
            Role(roleName: "Thần Tình Yêu", image: "cupid", roleDes: "Kết nối hai người chơi thành cặp tình nhân. Nếu một người chết, người kia cũng sẽ chết.", roleType: .Good),
            Role(roleName: "Sát Thủ", image: "killer", roleDes: "Hoạt động một mình, ám sát người chơi khác để giành chiến thắng.", roleType: .Neutral),
            Role(roleName: "Thằng Ngố", image: "clown", roleDes: "Cố gắng để bị treo cổ nhằm đạt được chiến thắng.", roleType: .Neutral),
            Role(roleName: "Dân Làng", image: "farmer", roleDes: "Một dân làng bình thường, không có năng lực đặc biệt.", roleType: .Good),
            Role(roleName: "Tiên Tri", image: "seer", roleDes: "Mỗi đêm, có thể nhìn ra vai trò của một người chơi.", roleType: .Good),
            Role(roleName: "Phù Thủy", image: "witch", roleDes: "Có hai lọ thuốc: một để cứu và một để giết.", roleType: .Good),
            Role(roleName: "Bác Sĩ", image: "doctor", roleDes: "Cứu một người chơi khỏi cái chết mỗi đêm.", roleType: .Good),
            Role(roleName: "Thợ Săn", image: "hunter", roleDes: "Có thể bắn một người chơi khi bị chết.", roleType: .Good),
            Role(roleName: "Ma Sói Đầu Đàn", image: "leadwolf", roleDes: "Dẫn dắt bầy sói và chọn mục tiêu mỗi đêm.", roleType: .Bad),
            Role(roleName: "Ma Sói", image: "wolf", roleDes: "Cùng các ma sói khác tiêu diệt dân làng vào ban đêm.", roleType: .Bad)
        ]
        
        for role in roles{
            modelContext.insert(role)
        }
        print("added")
    }
}

#Preview {
    MainView()
}

