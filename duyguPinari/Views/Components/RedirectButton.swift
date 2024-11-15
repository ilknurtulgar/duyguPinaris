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
    let action:()->Void
    var body: some View {
        Button(action:action){
            HStack {
                icon
                    .resizable()
                    .frame(width: 18, height: 18)
                    .padding(.leading, 20)
                    .foregroundColor(Color.textColor)
                TextStyles.subtitleMedium(title)
                    .padding(.leading, 15)
                Spacer()
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

