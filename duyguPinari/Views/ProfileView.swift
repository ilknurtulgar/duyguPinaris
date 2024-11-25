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
    
    var body: some View {
        NavigationStack {
            ZStack {
                ScrollView {
                    VStack {
                        ProfileImage()
                            .padding(.top, 100)
                        
                        TextStyles.title("Rachel Green")
                            .padding(.top, 18)
                            .padding(.bottom, 18)
                        
                        Text("A creative and dedicated software developer...")
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
                                destination = .logout
                            }
                        )
                        .padding(.bottom, 14)
                    }
                    .padding(.horizontal, 16)
                }
            }
            .navigationDestination(isPresented: .constant(destination == .editProfile)) {
                EditProfileView(showBottomTabBar: $showBottomTabBar)
                    .navigationBarBackButtonHidden(true)
                    .onAppear{
                        showBottomTabBar = false
                    }
                    .onDisappear{
                        destination = nil
                        
                        
                    }
            }
            .navigationDestination(isPresented: .constant(destination == .feedbacks)) {
                FeedbacksView(showBotttomTabBar: $showBottomTabBar)
                
                    .onAppear{
                        showBottomTabBar = false
                    }
                    .onDisappear{
                        
                        destination = nil
                    }
                    .navigationBarBackButtonHidden(true)
            }
            /* .navigationDestination(isPresented: .constant(destination == .logout)) {
             ProfileView(showBottomTabBar: $showBottomTabBar)
             }*/
        }
    }
}








/*#Preview {
 ProfileView()
 }*/
