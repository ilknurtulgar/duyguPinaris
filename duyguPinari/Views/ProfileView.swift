//
//  ProfileView.swift
//  duyguPinari
//
//  Created by İlknur Tulgar on 7.11.2024.
//

import SwiftUI
struct ProfileView: View {
    @State private var path = NavigationPath()
    @Binding var showBottomTabBar : Bool
    var body: some View {
        NavigationStack(path:$path){
            ZStack{
                Color.backgroundPrimary.ignoresSafeArea()
                ScrollView{
                    VStack {
                        
                        ProfileImage()
                            .padding(.top,100)
                        TextStyles.title("Rachel Green")
                            .padding(.top,18)
                            .padding(.bottom,18)
                        
                        Text("A creative and dedicated software developer with a strong background in full-stack development, they have a knack for turning complex problems into simple, user-friendly solutions. Passionate about technology and innovation, they enjoy working on projects that challenge their skills and push the boundaries of what's possible. When not coding, they love exploring the latest trends in AI and enjoy collaborating with diverse teams to bring new ideas to life.")
                            .customAboutText()
                        Spacer()
                        
                        NavigationLink(value: "editProfile") {
                            CustomRedirectButton(icon: Image(systemName: "pencil.and.ellipsis.rectangle"),title: "Profil Düzenleme" ,action:{path.append("editProfile")
                                
                            })
                            .padding(.bottom, 14)
                        }
                        NavigationLink(value: "feedbacks"){ CustomRedirectButton(icon: Image(systemName: "bubble.left.and.bubble.right.fill"),title: "Geri Bildirimler",action: {path.append("feedbacks")})
                        }
                        .padding(.bottom, 14)
                        CustomRedirectButton(icon: Image(systemName: "xmark.circle"),title: "Çıkış",action: {})
                            .padding(.bottom, 14)
                        
                        
                    }
                    
                }
                
                .padding(.top)
            }
            .navigationDestination(for: String.self) { value in
                if value == "editProfile" {
                    EditProfileView(showBottomTabBar: $showBottomTabBar)
                        .navigationBarBackButtonHidden(true)
                }
                if value == "feedbacks"{
                    FeedbacksView()
                        .navigationBarBackButtonHidden(true)
                }
                
                
            }
        }
    }
}


/*#Preview {
 ProfileView()
 }*/
