//
//  ProfileView.swift
//  duyguPinari
//
//  Created by İlknur Tulgar on 7.11.2024.
//

import FirebaseAuth
import SwiftUI

enum Destination: Hashable {
    case editProfile
    case feedbacks
    case logout
}

struct ProfileView: View {
    @Binding var showBottomTabBar: Bool
    @State private var destination: Destination?
    @EnvironmentObject var appState: AppState
    @State private var showAlert: Bool = false
     @State private var alertMessage: String = ""
    private let viewModel = ProfileViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.backgroundPrimary.ignoresSafeArea()
                ScrollView {
                    VStack {
                        ProfileImage(imageURL: appState.currentUser?.profileImageURL)
                            .padding(.top, 50)
                        TextStyles.title(appState.currentUser?.username ?? "nullim")
                            .padding(.top, 18)
                            .padding(.bottom, 18)
                        
                        Text(appState.currentUser?.about ?? "Hakkında bilgisi bulunmamaktadır.")
                            .customAboutText()
                        
                        Spacer()
                        
                        CustomRedirectButton(
                            icon: Image(systemName: "pencil.and.ellipsis.rectangle"),
                            title: "Profil Düzenleme",
                            action: {
                                showBottomTabBar = false
                                destination = .editProfile
                            }
                        )
                        .padding(.bottom, 14)
                        
                        CustomRedirectButton(
                            icon: Image(systemName: "bubble.left.and.bubble.right.fill"),
                            title: "Geri Bildirimler",
                            action: {
                                showBottomTabBar = false
                                destination = .feedbacks
                            }
                        )
                        .padding(.bottom, 14)
                        
                        CustomRedirectButton(icon: Image(systemName: "person.2.circle"), title: "Dinleyici",isTalk: true,action: {
                            handleTalkStateUpdate()
                        })
                            .padding(.bottom,14)
                        
                        CustomRedirectButton(
                            icon: Image(systemName: "xmark.circle"),
                            title: "Çıkış",
                            action: {
                                showBottomTabBar = false
                                appState.isLoggedIn = false
                                appState.selectedTab = "Home"
                                appState.currentUser = nil
                                do{
                                    try Auth.auth().signOut()
                                    print("çıkış")
                                    appState.chatUsers = []
                                    destination = .logout
                                }catch{
                                    print("error signing out: \(error.localizedDescription)")
                                }
                           
                                
                            }
                        )
                        .padding(.bottom, 14)
                    }
                    .padding(.horizontal, 16)
                }
            }
            .alert(isPresented: $showAlert){
                Alert(title: Text("E mail Doğrulama Gerekli"),
                      message: Text(alertMessage),
                      dismissButton: .default(Text("Tamam"))
                )
            }
            .navigationDestination(isPresented: .constant(destination == .editProfile)) {
                EditProfileView(appState: appState, showBottomTabBar: $showBottomTabBar)
                    .navigationBarBackButtonHidden(true)
                    .onAppear {
                        showBottomTabBar = false
                    }
                    .onDisappear {
                        destination = nil
                    }
            }
            .navigationDestination(isPresented: .constant(destination == .feedbacks)) {
                FeedbacksView(appState: appState, showBottomTabBar: $showBottomTabBar)
                    .navigationBarBackButtonHidden(true)
                    .onAppear {
                        showBottomTabBar = false
                    }
                    .onDisappear {
                        destination = nil
                    }
            }
        }
     
    }
    private func handleTalkStateUpdate() {
        guard let currentUser = Auth.auth().currentUser else { return }
        
        if currentUser.isEmailVerified {
            // E-posta doğrulanmışsa talkState güncellenebilir
            if let user = appState.currentUser {
                let newState = !(user.talkState ?? false)
                appState.currentUser?.talkState = newState
                viewModel.updateTalkState(id: user.id, newTalkState: newState) { result in
                    switch result {
                    case .success():
                        print("TalkState updated")
                    case .failure(let error):
                        print("Failed to update TalkState: \(error.localizedDescription)")
                    }
                }
            }
        } else {
            alertMessage = "Dinleyici modunu aktif etmek için e mail doğrulamanız gerekiyor. Lütfen e mail adresinizi kontrol edin."
            showAlert = true
        }
    }
}









/*#Preview {
 ProfileView()
 }*/
