//
//  RedirectButton.swift
//  duyguPinari
//
//  Created by İlknur Tulgar on 7.11.2024.
//

import SwiftUI

struct CustomRedirectButton: View {
    let icon: Image
    let title: String
    var isTalk: Bool?
    let action: () -> Void
    var shadow: Bool = false
    @EnvironmentObject var appState: AppState

    var body: some View {
        Button(action: {
            action()
        }) {
            HStack {
                icon
                    .resizable()
                    .frame(width: 15, height: 15)
                    .foregroundColor(Color.textColor)
                TextStyles.subtitleMedium(title)
                    .padding(.leading, 10)
                Spacer()
                if isTalk == true {
                   
                    Toggle(
                        isOn: Binding(
                            get: { appState.currentUser?.talkState ?? false },
                            set: { appState.currentUser?.talkState = $0 }
                        )
                    ) {
                        // Empty label for Toggle
                    }
                    .padding(.trailing, 5) // Tutarlı padding
                    .toggleStyle(SwitchToggleStyle(tint: Color.primaryColor))
                    .scaleEffect(0.6)
                   
                }
            }
            .frame(width: 295, height: 40)
            .padding(.leading,10)
            .background(Color.white)
            .cornerRadius(15)
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(Color.secondaryColor, lineWidth: 1)
            )
            .shadow(
                color: shadow ? .black.opacity(0.2) : .clear,
                radius: shadow ? 5 : 0,
                x: 0,
                y: 3
            )
        }
    }
}

