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
    let icon: Image?
    let action: (() -> Void)?
    let userImageURL: String?
    let hasUserImage: Bool // Kullanıcı resmi varsa farklı padding uygulamak için
    let titleAlignment: TextAlignment
    let textAction: (() -> Void)? // Metin tıklama eylemi
    let paddingSize: CGFloat
    
    var body: some View {
        VStack {
            HStack {
                // Sol İkon
                if let icon = icon, let action = action {
                    Button(action: action) {
                        icon
                            .frame(width: 24, height: 24)
                            .padding(.leading, 40)
                            .foregroundColor(Color.textColor)
                    }
                } else {
                    Spacer()
                        .frame(width: 24)
                }
                
                // Kullanıcı Resmi
                if hasUserImage, let userImageURL = userImageURL {
                    AsyncImage(url: URL(string: userImageURL)) { phase in
                        switch phase {
                        case .empty:
                            Image(systemName: "person.circle")
                                .resizable()
                                .scaledToFit()
                                .clipShape(Circle())
                                .frame(width: 35, height: 35)
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFit()
                                .clipShape(Circle())
                                .frame(width: 35, height: 35)
                        case .failure:
                            Image(systemName: "person.circle")
                                .resizable()
                                .clipShape(Circle())
                                .frame(width: 24, height: 24)
                        @unknown default:
                            EmptyView()
                        }
                    }
                    .padding(.leading, 10)
                }
                
                // Metin (tıklanabilir hale getirme)
                if hasUserImage, let textAction = textAction {
                    Button(action: textAction) {
                        TextStyles.title(title)
                            .multilineTextAlignment(titleAlignment)
                            .foregroundColor(Color.textColor)
                            .padding(.leading, hasUserImage ? 10 : 70)
                    }
                } else {
                    TextStyles.title(title)
                        .multilineTextAlignment(titleAlignment)
                        .foregroundColor(Color.textColor)
                        .padding(.leading, paddingSize)
                }
                Spacer()
            }
            .frame(width: 430, height: 40)
            
            // Alt Çizgi
            Rectangle()
                .frame(height: 1)
                .foregroundColor(.secondaryColor)
        }
        .padding(.horizontal, 10)
        .padding(.top, 30)
    }
}
