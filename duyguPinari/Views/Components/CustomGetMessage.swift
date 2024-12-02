//
//  CustomGetMessage.swift
//  duyguPinari
//
//  Created by İlknur Tulgar on 2.12.2024.
//

import SwiftUI

struct CustomGetMessage: View {
    let message: String
    let isCurrentUser: Bool
    let time: String

    var body: some View {
        HStack {
            if isCurrentUser {
                Spacer() // Mesajı sağ tarafa itmek için
            }

            VStack(alignment: isCurrentUser ? .trailing : .leading) {
                // Mesaj içeriği
                Text(message)
                    .padding(10)
                    .foregroundColor(.textColor)
                    .background(Color.white)
                    .customCornerRadius(15, corners:  isCurrentUser ?  [.topRight, .bottomRight] : [.topLeft, .bottomLeft] )
                    .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(Color.primaryColor, lineWidth: 2) // Kenar rengi daha belirgin
                            .customCornerRadius(15, corners: isCurrentUser ?  [.topRight, .bottomRight] : [.topLeft, .bottomLeft] )
                    )
                    .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2) // Shadow'u biraz daha belirginleştirdik
                    .frame(maxWidth: UIScreen.main.bounds.width * 0.7, alignment: isCurrentUser ? .trailing : .leading) // Maksimum genişlik ayarı
                // Zamanı mesajın altında göstermek
                Text(time)
                    .font(.footnote)
                    .foregroundColor(.gray)
                    .padding(.top, 2) // Zamanın biraz daha yukarıda olmasını sağlamak
                    .frame(maxWidth: .infinity, alignment: isCurrentUser ? .trailing : .leading) // Zaman hizalaması
                
            }
            .padding(isCurrentUser ? .trailing : .leading, 10) // Mesajın iç hizalaması
            .padding(.vertical, 5)
            
            if !isCurrentUser {
                Spacer() // Mesajı sol tarafa itmek için
            }
        }
        .padding(isCurrentUser ? .leading : .trailing, 50) // Mesajın dış paddingi
    }
}

