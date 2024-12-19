//
//  CustomAboutText.swift
//  duyguPinari
//
//  Created by İlknur Tulgar on 7.11.2024.
//

import SwiftUI

extension Text {
    func customAboutText(
        backgroundColor: Color? = nil,
        borderColor: Color? = nil,
        shadow: Bool = false,
        isTopic: Bool = false
    ) -> some View {
        self
            .frame(width: 295, alignment: isTopic ? .leading : .center)
            .fixedSize(horizontal: true, vertical: false)
            .font(.custom("SFPro-Display-Regular", size: 12))
            .foregroundColor(.textColor)
            .padding(.all,15)
            .background(
                backgroundColor.map { $0.cornerRadius(15) }
            )
            .overlay(
                borderColor.map {
                    RoundedRectangle(cornerRadius: 15)
                        .stroke($0, lineWidth: 1)
                }
            )
            .shadow(
                color: shadow ? .black.opacity(0.2) : .clear,
                radius: shadow ? 5 : 0,
                x: 0,
                y: 3
            )
    }
}


