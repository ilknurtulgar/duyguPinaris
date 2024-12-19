//
//  AboutView.swift
//  duyguPinari
//
//  Created by İlknur Tulgar on 2.12.2024.
//

import SwiftUI


extension View {
    func asText() -> Text {
        guard let text = self as? Text else {
            fatalError("This view is not a Text instance.")
        }
        return text
    }
}

struct AboutView: View {
    
    @State var isDone: Bool = false
    @State var backNavigate: Bool = false
    @State private var showAlert: Bool = false
    @Binding var showBottomTabBar: Bool
    @EnvironmentObject var appState: AppState
    var chatUser: ChatUser
    var about: String
    
    var body: some View {
        NavigationStack{
            ZStack {
                Color.backgroundPrimary.ignoresSafeArea()
                VStack(spacing: 0) {
                    CustomToolBar(title: chatUser.username, icon: Image(systemName: "chevron.left"), action: {
                       backNavigate = true
                        
                    }, userImageURL: chatUser.profileImage, hasUserImage: true, titleAlignment: .leading, textAction: nil,paddingSize: 10)
                    
                    ScrollView {
                        VStack(spacing: 20) {
                            ProfileImage(imageURL:chatUser.profileImage)
                                .padding(.top, 16)
                                .padding(.bottom,20)
                            TextStyles.subtitleMedium2("Hakkında:")
                                .frame(maxWidth: 430,alignment: .leading)
                                .padding(.leading,70)
                            TextStyles.subtitleMedium2(about == "" ? "Hakkında bilgisi bulunmamaktadır." : about)
                                .asText()
                                .customAboutText(backgroundColor: Color.white,borderColor: Color.secondaryColor,shadow: true)
                            
                            TextStyles.subtitleMedium2("Konu:")
                                .frame(maxWidth: 430,alignment: .leading)
                                .padding(.leading,70)
                            
                            TextStyles.subtitleMedium(chatUser.topic ?? "")
                            
                                .asText()
                                .customAboutText(backgroundColor: Color.white,borderColor: Color.secondaryColor,shadow: true,isTopic: true)
                                .multilineTextAlignment(.leading)
                            CustomRedirectButton(icon: Image(systemName: "xmark"), title: "Konuşmayı Bitir", action: {
                                showAlert = true
                            },shadow: true)
                            .frame(maxWidth: 430,alignment: .leading)
                            .padding(.leading,70)
                            .padding(.top,15)
                            
                        }
                    }
                }
                .navigationDestination(isPresented: $isDone){
                    AddFeedbackView(showBottomTabBar: $showBottomTabBar,chatUser: chatUser)
                        .navigationBarBackButtonHidden(true)
                        .environmentObject(appState)
                        .onAppear {
                            showBottomTabBar = false
                        }
                        .onDisappear{
                            isDone = false
                        }
                      
                }
                .navigationDestination(isPresented: $backNavigate){
                ChatView(showBottomTabBar: $showBottomTabBar,chatUser: chatUser)
                        .navigationBarBackButtonHidden(true)
                        .environmentObject(appState)
                        .onDisappear{
                            backNavigate = false
                        }
                      
                }
                .alert("Konuşmayı Bitirme", isPresented: $showAlert) {
                    Button("Hayır", role: .cancel) { }
                    Button("Evet") {
                      isDone = true
                    }
                } message: {
                    Text("Konuşma silinecektir. Geri bildirim vermek ister misiniz?")
                }
            }
        }
    }
}




/*#Preview {
    AboutView()
}*/
