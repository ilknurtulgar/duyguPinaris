//
//  ProfileView.swift
//  duyguPinari
//
//  Created by İlknur Tulgar on 7.11.2024.
//

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
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.backgroundPrimary.ignoresSafeArea()
                ScrollView {
                    VStack {
                        ProfileImage()
                            .padding(.top, 100)
                        
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
                        
                        CustomRedirectButton(
                            icon: Image(systemName: "xmark.circle"),
                            title: "Çıkış",
                            action: {
                                showBottomTabBar = false
                                appState.isLoggedIn = false
                                appState.selectedTab = "Home"
                                appState.currentUser = nil
                                destination = .logout
                                
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
