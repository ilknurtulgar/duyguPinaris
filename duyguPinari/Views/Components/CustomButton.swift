//
//  CustomButton.swift
//  duyguPinari
//
//  Created by İlknur Tulgar on 18.11.2024.
//

import SwiftUI

struct CustomButton: View {
    let title: String
    let width: CGFloat
    let height: CGFloat
    let backgroundColor: Color
    let borderColor: Color
    let cornerRadius: CGFloat = 15
    let  textcolor : Color
    let action: () -> Void
    let font:Font

    var body: some View {
        Button(action: {
            action()
        }) {
            Text(title)
                .frame(width: width, height: height)
                .background(backgroundColor)
                .foregroundColor(textcolor)
                .cornerRadius(cornerRadius)
                .overlay(
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .stroke(borderColor, lineWidth: 1)
                )
                .font(font)
        }
    }
}
