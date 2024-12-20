//
//  RoleLibrary.swift
//  Werewolf
//
//  Created by Trịnh Kiết Tường on 11/12/24.
//
//
//  RoleLibrary.swift
//  Werewolf
//
//  Created by Trịnh Kiết Tường on 11/12/24.
//

import SwiftUI
import SwiftData

struct RoleLibrary: View {
    @Query var roles: [Role]
    @Environment(\.modelContext) private var context

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 15) {
                ForEach(roles, id: \ .id) { role in
                    RoleCard(role: role)
                }
            }
            .padding()
        }
        .background(Color(UIColor.systemBackground)) // Adapts to light/dark mode
        .navigationTitle("Thư viện vai trò")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {
                    print("Add Role")
                }) {
                    Image(systemName: "plus")
                }
            }
        }
    }
}

// MARK: - RoleCard Subview

struct RoleCard: View {
    let role: Role

    var body: some View {
        HStack(spacing: 15) {
            Circle()
                .foregroundStyle(.gray.opacity(0.3))
                .frame(width: 80, height: 80)
                .overlay {
                    Image(role.image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 75, height: 75)
                        .clipShape(Circle())
                }
                .shadow(color: .black.opacity(0.2), radius: 3, x: 2, y: 2)

            VStack(alignment: .leading, spacing: 8) {
                Text(role.roleName)
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundStyle(.primary)

                Text(role.roleDes)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }
            Spacer()

            Text(role.roleTypeDescription)
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(role.roleTypeColor)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(role.roleTypeColor.opacity(0.15))
                .clipShape(Capsule())
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(UIColor.secondarySystemBackground)) // Adaptable background
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 4)
        )
    }
}

// MARK: - Role Extensions for Role Type Info

extension Role {
    var roleTypeDescription: String {
        switch roleType {
        case .Good: return "Phe Dân"
        case .Bad: return "Phe Sói"
        case .Neutral: return "Phe thứ 3"
        }
    }

    var roleTypeColor: Color {
        switch roleType {
        case .Good: return .green
        case .Bad: return .red
        case .Neutral: return .yellow
        }
    }
}

// MARK: - Preview

#Preview {
    NavigationView {
        RoleLibrary()
    }
}
