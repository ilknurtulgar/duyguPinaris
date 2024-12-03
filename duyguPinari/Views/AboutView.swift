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
    @State var isActive: Bool
    @State var isDone: Bool = false
    @Environment(\.dismiss) private var dismiss
    @State private var showAlert: Bool = false
    @Binding var showBottomTabBar: Bool
    var chatUser: ChatUser
    var about: String
    var body: some View {
        NavigationStack{
            ZStack {
                Color.backgroundPrimary.ignoresSafeArea()
                VStack(spacing: 0) {
                    CustomToolBar(title: chatUser.username, icon: Image(systemName: "chevron.left"), action: {
                        dismiss()
                        isActive = false // ChatView'e dönmek için
                    }, userImageURL: "", hasUserImage: true, titleAlignment: .leading, textAction: nil,paddingSize: 10)
                    
                    ScrollView {
                        VStack(spacing: 20) {
                            ProfileImage()
                                .padding(.top, 16)
                                .padding(.bottom,20)
                            TextStyles.subtitleMedium2("Hakkında:")
                                .frame(maxWidth: 430,alignment: .leading)
                                .padding(.leading,70)
                            TextStyles.bodyRegular(about)
                                .asText()
                                .customAboutText(backgroundColor: Color.white,borderColor: Color.secondaryColor,shadow: true)
                            
                            TextStyles.subtitleMedium2("Konu:")
                                .frame(maxWidth: 430,alignment: .leading)
                                .padding(.leading,70)
                            
                            TextStyles.bodyRegular(chatUser.topic ?? "")
                            
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
                    AddFeedbackView(showBottomTabBar: $showBottomTabBar)
                        .navigationBarBackButtonHidden(true)
                        .onAppear {
                            showBottomTabBar = false
                        }
                        .onDisappear{
                            isDone = false
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
