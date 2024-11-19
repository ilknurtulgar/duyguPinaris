//
//  ChatListCard.swift
//  duyguPinari
//
//  Created by İlknur Tulgar on 19.11.2024.
//

import SwiftUI
struct ChatListCard: View {
    var profileImage: Image
    var title: String
    var messageDetails: String
    var unreadMessages: Int
    var body: some View{
        NavigationLink(destination: ChatView()){
            HStack{
                profileImage
                    .resizable()
                    .frame(width: 50,height: 50)
                    .clipShape(Circle())
                    .padding(.leading,25)
                VStack(alignment: .leading,spacing: 10){
                    TextStyles.subtitleMedium(title)
                    TextStyles.bodyRegular(messageDetails)
                }
                
                Spacer()
                if unreadMessages > 0{
                    ZStack{
                        Circle()
                            .fill(Color.white)
                            .frame(width: 20,height: 20)
                            .overlay(
                                Circle()
                                    .stroke(Color.primaryColor,lineWidth: 1))
                            .shadow(color: Color.gray.opacity(0.4), radius: 2,x:0,y:2)
                        TextStyles.bodyRegular("\(unreadMessages)")
                    }
                    .padding(.trailing,25)
                }
                
            }
            .frame(width: 340,height: 75)
            .background(
                RoundedRectangle(cornerRadius: 30)
                    .stroke(Color.secondaryColor,lineWidth: 1)
                    .background(Color.white.cornerRadius(30))
                    .shadow(color: Color.gray.opacity(0.2), radius: 4, x: 0 ,y: 2)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}
