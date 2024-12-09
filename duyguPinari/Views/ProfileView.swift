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
    private let viewModel = ProfileViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.backgroundPrimary.ignoresSafeArea()
                ScrollView {
                    VStack {
                        ProfileImage()
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
                            if let currentUser = appState.currentUser{
                                let newState = !(currentUser.talkState ?? false)
                                appState.currentUser?.talkState = newState
                                viewModel.updateTalkState(id: currentUser.id, newTalkState: newState){
                                    result in
                                    switch result {
                                    case .success():
                                        print("takstate updated")
                                    case .failure(let failure):
                                        print("talkstate didnt update: \(failure.localizedDescription)")
                                    }
                                }
                            }
                            
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
}









/*#Preview {
 ProfileView()
 }*/
