//
//  HomeView.swift
//  duyguPinari
//
//  Created by İlknur Tulgar on 6.11.2024.
//

import SwiftUI
import FirebaseAuth

struct HomeView: View {
    @State private var navigateToFilterView: Bool = false
    @Binding var showBottomTabBar: Bool
    @State private var isChat: Bool = false
    @EnvironmentObject var appState: AppState
    @State private var selectedChatUser: ChatUser?
    @StateObject var viewModel: HomeViewModel
    @State private var alertMessage: String = ""
    @State private var showAlert: Bool = false
    
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
                            guard let currentUser = Auth.auth().currentUser else {return}
                            if currentUser.isEmailVerified{
                                showBottomTabBar=false
                                navigateToFilterView=true
                            }else {
                                alertMessage = "Konuşma başlatabilmek için e-postanızı doğrulamanız gerekiyor. E-postanıza gönderilen doğrulama bağlantısını kullanarak doğrulayabilirsiniz."
                                showAlert = true
                            }
                          
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
                                    ChatListCard(profileImageURL: user.profileImage, title: user.username, messageDetails: user.lastMessage ?? "Sohbete başlamak için tıklayın", unreadMessages: user.unreadMessage, showBottomTabBar: $showBottomTabBar, action: {
                                        showBottomTabBar = false
                                        isChat = true
                                        print("User Profile Image URL: \(String(describing: user.profileImage))")
                                        selectedChatUser = user
                                        print("chatuserId:\(user.id)")
                                        print("username:\(user.username)")
                                        print("test:\(String(describing: user.role))")
                                        
                                        // mesaj gelince lasti güncellme
                                        
                                    })
                                }
                            }
                        }
                    }
                    .padding(.top,30)
                }
            }
            .alert(isPresented: $showAlert){
                Alert(title: Text("E mail Doğrulama gerekli"),
                message: Text(alertMessage),
                      primaryButton: .default(Text("Tekrar Gönder")){
                    sendEmailVerification()
                },secondaryButton: .cancel(Text("Tamam"))
                
                )
            }
        }
        
        .navigationDestination(isPresented: $navigateToFilterView){
            StartChattingView(showBottomTabBar: $showBottomTabBar)
              
                .onDisappear{
                    showBottomTabBar=true
                }
                .environmentObject(appState)
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
            guard let userId = appState.currentUser?.id, !userId.isEmpty else {
                 print("Kullanıcı ID'si yok, sohbetler çekilmiyor.")
                 return
             }
             viewModel.fetchChatUsers(for: userId) {
                 print("Sohbet kullanıcıları alındı.")
             }
        }
    }
    private func sendEmailVerification(){
        Auth.auth().currentUser?.sendEmailVerification{error in
            if let error = error {
                alertMessage = "Doğrulama e mail gönderilirken bir hata oluştu:\(error.localizedDescription)"
                showAlert = true
            }else {
                alertMessage = "Doğrulama e-postası tekrar gönderildi. Lütfen e-postanızı kontrol edin."
            showAlert = true
            }
        }
    }
}




/*#Preview {
 HomeView()
 }*/

