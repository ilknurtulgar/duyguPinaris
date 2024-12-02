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
    @State private var destination: String?
    @EnvironmentObject var appState: AppState
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
                                ForEach(viewModel.chatUsers){user in
                                    ChatListCard(profileImageURL: user.profileImage, title: user.username, messageDetails: user.message, unreadMessages: user.unreadMessage, showBottomTabBar: $showBottomTabBar, action: {
                                        showBottomTabBar = false
                                        destination = "chat"
                                    })
                                }
                            }
                        }
                        .padding(.top,30)
                    }
                }
            }
        
            .navigationDestination(isPresented: $navigateToFilterView){
                StartChattingView(showBottomTabBar: $showBottomTabBar)
                    .onDisappear{
                        showBottomTabBar=true
                    }
                    .navigationBarBackButtonHidden(true)
            }
            
            .navigationDestination(isPresented: .constant(destination == "chat")){
                ChatView(showBottomTabBar: $showBottomTabBar)
                    .onAppear{
                        showBottomTabBar = false
                    }
                    .onDisappear{
                        destination = nil
                        
                    }
                    .navigationBarBackButtonHidden(true)
            }
            .navigationBarHidden(true)
           .onAppear {
               viewModel.fetchChatUsers(for: appState.currentUser?.id ?? "") {
                   
               } // ilk yükleme
           
                  }
           
        }
    }
    
}


/*#Preview {
 HomeView()
 }*/

