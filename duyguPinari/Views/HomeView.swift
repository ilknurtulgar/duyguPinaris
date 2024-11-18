//
//  HomeView.swift
//  duyguPinari
//
//  Created by İlknur Tulgar on 6.11.2024.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationView{
            ZStack{
                Color.backgroundPrimary.ignoresSafeArea()
                VStack{
                    HStack{
                        Spacer()
                        AddConversationButton(action: {})
                    }
                    .padding(.top,10)
                    .padding(.trailing,100)
                    
                    ScrollView{
                        VStack(spacing: 45){
                            ChatListCard(profileImage: Image(systemName: "person.circle"), title: "Alexa", messageDetails: "How you doin?", unreadMessages: 2)
                            ChatListCard(profileImage: Image(systemName: "person.circle"), title: "Rachel", messageDetails: "How you doin?", unreadMessages: 1)
                        }
                        .padding(.top,30)
                    }
                }
            }
        }
    }
}

#Preview {
    HomeView()
}

