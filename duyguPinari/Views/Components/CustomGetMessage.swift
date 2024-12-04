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
    var profileImageURL: String?
    let time: String

    var body: some View {
        HStack(alignment: .top, spacing: 10) { // HStack içerisindeki öğeleri hizalamak için
            if !isCurrentUser, let userImageURL = profileImageURL {
                VStack {
                    AsyncImage(url: URL(string: userImageURL)) { phase in
                        switch phase {
                        case .empty:
                            Image(systemName: "person.circle")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40)
                                .clipShape(Circle())
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40)
                                .clipShape(Circle())
                        case .failure:
                            Image(systemName: "person.circle")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .clipShape(Circle())
                        @unknown default:
                            EmptyView()
                        }
                    }
                }
            }

            // Mesaj kutusu ve zamanın hizalanması
            VStack(alignment: isCurrentUser ? .trailing : .leading) {
                ZStack {
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(Color.primaryColor, lineWidth: 1)
                        .background(Color.white)
                        .cornerRadius(15)
                        .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)

                    VStack(alignment: isCurrentUser ? .trailing : .leading) {
                        TextStyles.subtitleMedium2(message)
                            .foregroundColor(.textColor)
                            .multilineTextAlignment(isCurrentUser ? .trailing : .leading)
                            .lineLimit(nil)

                        TextStyles.bodyRegular(time)
                            .font(.footnote)
                            .foregroundColor(.gray)
                            .padding(.top, 2)
                            .multilineTextAlignment(isCurrentUser ? .leading : .trailing)
                    }
                }
                .frame(minWidth: 50, maxWidth: 250, minHeight: 40, alignment: isCurrentUser ? .trailing : .leading) // Mesaj kutusunu hizalamak
            }

            // Kullanıcı resmi
            if isCurrentUser, let userImageURL = profileImageURL {
                VStack {
                    AsyncImage(url: URL(string: userImageURL)) { phase in
                        switch phase {
                        case .empty:
                            Image(systemName: "person.circle")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40)
                                .clipShape(Circle())
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40)
                                .clipShape(Circle())
                        case .failure:
                            Image(systemName: "person.circle")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .clipShape(Circle())
                        @unknown default:
                            EmptyView()
                        }
                    }
                }
            }
        }
        .padding(isCurrentUser ? .leading : .trailing, 15) // Mesajın etrafındaki padding
        .frame(maxWidth: .infinity, alignment: isCurrentUser ? .trailing : .leading) // Mesaj kutusunu sağa veya sola hizalamak
    }
}


