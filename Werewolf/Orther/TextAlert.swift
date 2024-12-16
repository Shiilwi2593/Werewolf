//
//  TextAlert.swift
//  Werewolf
//
//  Created by Trịnh Kiết Tường on 11/12/24.
//

import SwiftUI

extension View {
    func alert(_ title: String, isPresented: Binding<Bool>, _ textAlert: TextAlert) -> some View {
        self.modifier(TextAlertModifier(title: title, isPresented: isPresented, textAlert: textAlert))
    }
}

struct TextAlert {
    let title: String
    let message: String?
    let placeholder: String
    let defaultText: String?
    let completion: (String?) -> Void
}

struct TextAlertModifier: ViewModifier {
    let title: String
    @Binding var isPresented: Bool
    let textAlert: TextAlert

    func body(content: Content) -> some View {
        content.alert(isPresented: $isPresented) {
            Alert(
                title: Text(textAlert.title),
                message: textAlert.message != nil ? Text(textAlert.message!) : nil,
                primaryButton: .default(Text("OK"), action: {
                    textAlert.completion(textAlert.defaultText)
                }),
                secondaryButton: .cancel()
            )
        }
    }
}
