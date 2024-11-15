//
//  customToolBar.swift
//  duyguPinari
//
//  Created by İlknur Tulgar on 14.11.2024.
//

import Foundation
import SwiftUI

struct CustomToolBar: View {
    let title: String
    let icon: Image
    let action: () -> Void
    var body: some View {
        VStack{
            HStack {
                Button(action: action) {
                    icon
                        .frame(width: 24, height: 24)
                        .padding(.leading, 20)
                        .foregroundColor(Color.textColor)
                }
                Spacer()
                TextStyles.title(title)
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color.textColor)
                Spacer()
                
            }
            .frame(width: 430, height: 40)

                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(.secondaryColor)
        }
        .frame(width: 430)
    }
}
