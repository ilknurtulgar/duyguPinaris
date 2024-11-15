//
//  withHorizontalLinesAndText.swift
//  duyguPinari
//
//  Created by İlknur Tulgar on 7.11.2024.
//

import Foundation
import SwiftUI

extension View {
    func withHorizontalLinesAndText(_ text: String) -> some View {
        HStack {
            // Sol çizgi
            Rectangle()
                .frame(width: 115, height: 1)
                .foregroundColor(.secondaryColor)
            
            Text(text)
                .foregroundColor(.gray)
                .padding(.horizontal, 14)
            
            // Sağ çizgi
            Rectangle()
                .frame(width: 115, height: 1)
                .foregroundColor(.secondaryColor)
        }
        .padding(.vertical, 20)
    }
}
