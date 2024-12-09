//
//  HomeView.swift
//  duyguPinari
//
//  Created by İlknur Tulgar on 6.11.2024.
//

import SwiftUI

struct HomeView: View {
    @State private var navigateToFilterView: Bool = false
    @Binding var showBottomTabBar: Bool
    @State private var isChat: Bool = false
    @EnvironmentObject var appState: AppState
    @State private var selectedChatUser: ChatUser?
    @StateObject var viewModel: HomeViewModel
    
    init(showBottomTabBar: Binding<Bool>, appState: AppState) {
        _viewModel = StateObject(wrappedValue: HomeViewModel(appState: appState))
        _showBottomTabBar = showBottomTabBar
    }
    
    var body: some View {
        NavigationStack{
            ZStack{
                Color.backgroundPrimary.ignoresSafeArea()
                VStack{
                    HStack{
                        Spacer()
                        AddConversationButton(action: {
                          //  print("home current: \(String(describing: appState.currentUser))")
                            showBottomTabBar=false
                            navigateToFilterView=true
                        })
                    }
                    .padding(.top,10)
                    .padding(.trailing,85)
                    
                    ScrollView{
                        VStack(spacing: 40){
                            if viewModel.chatUsers.isEmpty{
                                TextStyles.subtitleMedium("Mesaj oluşturmak için mesaj butonuna tıklayın\n ve sohbete başlayın!")
                                    .multilineTextAlignment(.center)
                                    .padding()
                                
                            }else {
                                ForEach(appState.chatUsers.sorted(by: { $0.timestamp ?? Date() > $1.timestamp ?? Date() })){user in
                                    ChatListCard(profileImageURL: user.profileImage, title: user.username, messageDetails: user.message, unreadMessages: user.unreadMessage, showBottomTabBar: $showBottomTabBar, action: {
                                        showBottomTabBar = false
                                        isChat = true
                                        selectedChatUser = user
                                        
                                        // mesaj gelince lasti güncellme
                                        
                                    })
                                }
                            }
                        }
                    }
                    .padding(.top,30)
                }
            }
        }
        
        .navigationDestination(isPresented: $navigateToFilterView){
            StartChattingView(showBottomTabBar: $showBottomTabBar)
                .environmentObject(appState)
                .onDisappear{
                    showBottomTabBar=true
                }
                .navigationBarBackButtonHidden(true)
        }
        
        .navigationDestination(isPresented: $isChat){
            
            if let selectedChatUser = selectedChatUser {
                
                ChatView(showBottomTabBar: $showBottomTabBar,chatUser: selectedChatUser)
                    .environmentObject(appState)
                    .onAppear{
                        showBottomTabBar = false
                    }
                
                    .navigationBarBackButtonHidden(true)
            }
        }
        .navigationBarHidden(true)
        .onAppear {
        /*    viewModel.fetchChatUsers(for: appState.currentUser?.id ?? "") {
             //   print("chat users fetched by homeview \(viewModel.chatUsers.count)")
            } // ilk yükleme
          */
            guard let userId = appState.currentUser?.id, !userId.isEmpty else {
                 print("Kullanıcı ID'si yok, sohbetler çekilmiyor.")
                 return
             }
             viewModel.fetchChatUsers(for: userId) {
                 print("Sohbet kullanıcıları alındı.")
             }
        }
    }
}




/*#Preview {
 HomeView()
 }*/

