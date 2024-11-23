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
        NavigationStack{
            ZStack {
                ScrollView {
                    VStack {
                        ProfileImage()
                            .padding(.top, 100)
                        TextStyles.title("Rachel Green")
                            .padding(.top, 18)
                            .padding(.bottom, 18)
                        
                        Text("A creative and dedicated software developer with a strong background in full-stack development, they have a knack for turning complex problems into simple, user-friendly solutions. Passionate about technology and innovation, they enjoy working on projects that challenge their skills and push the boundaries of what's possible. When not coding, they love exploring the latest trends in AI and enjoy collaborating with diverse teams to bring new ideas to life.")
                            .customAboutText()
                        Spacer()
                        
                        CustomRedirectButton(
                            icon: Image(systemName: "pencil.and.ellipsis.rectangle"),
                            title: "Profil Düzenleme",
                            action: {
                                destination = .editProfile
                            }
                        )
                        
                        .padding(.bottom, 14)
                        
                        CustomRedirectButton(
                            icon: Image(systemName: "bubble.left.and.bubble.right.fill"),
                            title: "Geri Bildirimler",action: {destination = .feedbacks}
                        )
                        .padding(.bottom, 14)
                        
                        CustomRedirectButton(
                            icon: Image(systemName: "xmark.circle"),
                            title: "Çıkış",action: {
                                destination = .logout
                            }
                        )
                        .padding(.bottom, 14)
                    }
                    .padding(.horizontal, 16)
                }
                .padding(.top)
            }
            .navigationDestination(for: Destination.self) { value in
                           switch value {
                           case .editProfile:
                               EditProfileView(showBottomTabBar: $showBottomTabBar)
                                   .navigationBarBackButtonHidden(true)
                           case .feedbacks:
                               FeedbacksView()
                           case .logout:
                               ProfileView(showBottomTabBar: $showBottomTabBar)
                           }
                       }
        }
    }
}








/*#Preview {
 ProfileView()
 }*/
