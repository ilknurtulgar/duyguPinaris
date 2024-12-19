//
//  ChatListCard.swift
//  duyguPinari
//
//  Created by İlknur Tulgar on 19.11.2024.
//

import SwiftUI

struct ChatListCard: View {
    var profileImageURL: String?
    var title: String
    var messageDetails: String
    var unreadMessages: Int
    @Binding var showBottomTabBar: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                // URL varsa AsyncImage ile resmi yükleyin
                if let url = profileImageURL, let imageURL = URL(string: url) {
                    AsyncImage(url: imageURL) { phase in
                        switch phase {
                        case .empty:
                            //Image(systemName: "person.circle")
                              //  .resizable()
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: Color.primaryColor))
                                .frame(width: 45, height: 45)
                                .scaleEffect(1.5)
                                .clipShape(Circle())
                                .padding(.all,7)
                          
                        case .success(let image):
                            image.resizable()
                                .frame(width: 45, height: 45)
                                .clipShape(Circle())
                                .padding(.all, 7)
                        case .failure:
                            // Resim yüklenemediğinde person.circle simgesini göster
                            Image(systemName: "person.circle")
                                .resizable()
                                .frame(width: 45, height: 45)
                                .clipShape(Circle())
                                .foregroundColor(.gray)
                                .padding()
                        @unknown default:
                            EmptyView()
                        }
                    }
                } else {
                    //URL yoksa, person.circle simgesini göster
                    Image(systemName: "person.circle")
                        .resizable()
                        .frame(width: 45, height: 45)
                        .clipShape(Circle())
                        .foregroundColor(.gray)
                        .padding()
                }
                
                VStack(alignment: .leading, spacing: 10) {
                    TextStyles.subtitleMedium(title)
                    TextStyles.bodyRegular(messageDetails)
                }
                
                Spacer()
                if unreadMessages > 0 {
                    ZStack {
                        Circle()
                            .fill(Color.white)
                            .frame(width: 20, height: 20)
                            .overlay(
                                Circle()
                                    .stroke(Color.primaryColor, lineWidth: 1)
                            )
                            .shadow(color: Color.gray.opacity(0.4), radius: 2, x: 0, y: 2)
                        TextStyles.bodyRegular("\(unreadMessages)")
                    }
                    .padding(.trailing, 25)
                }
            }
            .frame(width: 340, height: 75)
            .background(
                RoundedRectangle(cornerRadius: 30)
                    .stroke(Color.secondaryColor, lineWidth: 1)
                    .background(Color.white.cornerRadius(30))
                    .shadow(color: Color.gray.opacity(0.2), radius: 4, x: 0, y: 2)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}
