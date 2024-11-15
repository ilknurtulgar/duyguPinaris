//
//  BigButton.swift
//  duyguPinari
//
//  Created by İlknur Tulgar on 6.11.2024.
//

import Foundation
import SwiftUI

struct CustomButton: View {
    var title: String
    var width: CGFloat = 295
    var height: CGFloat = 40
    var backgroundColor: Color
    var borderColor: Color
    var cornerRadius: CGFloat = 15
    var  textcolor : Color
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .frame(width: width, height: height)
                .background(backgroundColor)
                .foregroundColor(textcolor)
                .cornerRadius(cornerRadius)
                .overlay(
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .stroke(borderColor, lineWidth: 1)
                )
        }
    }
}
