//
//  CustomAboutText.swift
//  duyguPinari
//
//  Created by İlknur Tulgar on 7.11.2024.
//

import Foundation
import SwiftUI

extension Text {
    func customAboutText() -> some View {
        self
            .font(.custom("SFPro-Display-Regular", size: 12))
            .foregroundColor(.textColor)
            .frame(width: 294, height: 150)
           // .padding()
            .cornerRadius(15)
    }
}


