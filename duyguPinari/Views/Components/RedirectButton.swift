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
    @EnvironmentObject var appState: AppState
    var body: some View {
        Button(action:{
            action()
        }){
            HStack() {
                icon
                    .resizable()
                    .frame(width: 18, height: 18)
                    .padding(.leading, 20)
                    .foregroundColor(Color.textColor)
                TextStyles.subtitleMedium(title)
                    .padding(.leading, 10)
                Spacer()
              if  isTalk == true {
                  Toggle(isOn:  Binding(get: {appState.currentUser?.talkState ?? false}, set: {appState.currentUser?.talkState = $0})){
    
                  }
                  .toggleStyle(SwitchToggleStyle(tint: Color.primaryColor))
                  .scaleEffect(0.6)
                  .padding(.leading,10)
                }
            }
            .frame(width: 295, height: 40)
            .background(Color.white)
            .cornerRadius(15)
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(Color.secondaryColor, lineWidth: 1))
          
        }
    }
}

