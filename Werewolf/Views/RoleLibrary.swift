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
                ForEach(roles, id: \.id) { role in
                    RoleRow(role: role)
                }
            }
            .padding()
        }
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

// MARK: - RoleRow Subview

struct RoleRow: View {
    let role: Role

    var body: some View {
        HStack {
            Circle()
                .foregroundStyle(.gray)
                .frame(width: 80, height: 80)
                .overlay {
                    Image(role.image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 75, height: 75)
                        .clipShape(Circle())
                }

            VStack(alignment: .leading, spacing: 5) {
                Text(role.roleName)
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundStyle(.primary) // Adapts to dark mode

                Text(role.roleDes)
                    .font(.subheadline)
                    .foregroundColor(.secondary) // Adapts to dark mode
                    .lineLimit(2)
            }
            Spacer()

            Text(role.roleTypeDescription)
                .foregroundStyle(.primary) // Adapts to dark mode
                .font(.caption)
                .padding(5)
                .background(role.roleTypeColor.opacity(0.2))
                .cornerRadius(5)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(.secondary)
                .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 3)
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
    RoleLibrary()
}
