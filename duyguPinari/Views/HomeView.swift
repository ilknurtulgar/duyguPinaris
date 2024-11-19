//
//  HomeView.swift
//  duyguPinari
//
//  Created by İlknur Tulgar on 6.11.2024.
//

import SwiftUI

struct HomeView: View {
    @State private var navigateToFilterView: Bool = false
    var body: some View {
        NavigationStack{
            ZStack{
                Color.backgroundPrimary.ignoresSafeArea()
                VStack{
                    HStack{
                        Spacer()
                        AddConversationButton(action: {
                            navigateToFilterView=true
                        })
                    }
                    .padding(.top,10)
                    .padding(.trailing,85)
                    
                    ScrollView{
                        VStack(spacing: 45){
                            ChatListCard(profileImage: Image(systemName: "person.circle"), title: "Alexa Richardson", messageDetails: "How you doin?", unreadMessages: 2)
                            ChatListCard(profileImage: Image(systemName: "person.circle"), title: "Rachel Green", messageDetails: "How you doin?", unreadMessages: 1)
                        }
                        .padding(.top,30)
                    }
                }
            }
        
            .navigationDestination(isPresented: $navigateToFilterView){
                StartChattingView()
                    .navigationBarBackButtonHidden(true)
            }
        }
    }
}

#Preview {
    HomeView()
}

