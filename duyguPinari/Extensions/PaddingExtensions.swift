//
//  PaddingExtensions.swift
//  duyguPinari
//
//  Created by İlknur Tulgar on 5.11.2024.
//

import Foundation
import SwiftUI

extension View {
    func HugeTitlePadding()-> some View{
        self.padding(.top,100)
            .padding(.bottom,65)
    }
}