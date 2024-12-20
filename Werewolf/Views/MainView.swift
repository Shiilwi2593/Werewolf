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
                    .zIndex(0)
                
                VStack(spacing: 30) {
                    NavigationLink(destination: LobbyView()) {
                        GameButton(title: "Bắt đầu game")
                    }
                    
                    NavigationLink(destination: PlayerLibrary()) {
                        GameButton(title: "Thư viện người chơi")
                    }
                    
                    NavigationLink(destination: RoleLibrary()) {
                        GameButton(title: "Thư viện vai trò")
                    }
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
            Role(roleName: "Sói Nguyền", image: "leadwolf", roleDes: "Dẫn dắt bầy sói và chọn mục tiêu mỗi đêm.", roleType: .Bad),
            Role(roleName: "Ma Sói", image: "wolf", roleDes: "Cùng các ma sói khác tiêu diệt dân làng vào ban đêm.", roleType: .Bad),
            Role(roleName: "Kẻ Phóng Hỏa", image: "arsonist", roleDes: "Mỗi đêm, có thể tẩm xăng một người chơi. Sau đó, vào bất kỳ đêm nào, có thể châm lửa để thiêu cháy tất cả những người đã bị tẩm xăng.", roleType: .Neutral),
            Role(roleName: "Sói Gây Mê", image: "hypnowolf", roleDes: "Mỗi đêm, có thể gây mê một người chơi để họ không thể thực hiện hành động vào đêm đó.", roleType: .Bad)
        ]
        
        for role in roles{
            modelContext.insert(role)
        }
        print("added")
    }
}

struct GameButton: View {
    let title: String
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color.white, Color.gray]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .frame(width: 300, height: 60)
            .cornerRadius(15)
            .shadow(color: Color.white.opacity(0.5), radius: 10, x: 0, y: 5)
            
            Text(title)
                .foregroundColor(.black)
                .font(.system(size: 20, weight: .bold, design: .rounded))
        }
    }
}

#Preview {
    MainView()
}

