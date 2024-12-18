//
//  SelectConversationView.swift
//  duyguPinari
//
//  Created by İlknur Tulgar on 19.11.2024.
//

import SwiftUI

struct SelectConversationView: View {
    @State private var navigateToAccept = false
    @Environment(\.dismiss) private var dismiss
    @Binding var matchedUser: User?
    @EnvironmentObject var appState: AppState
    @Binding var showBottomTabBar: Bool
    @StateObject private var viewModel = SelectConversationViewModel()
    var topic: String 
    var body: some View {
        
        NavigationStack{
            ZStack{
                Color.backgroundPrimary.ignoresSafeArea()
                VStack(){
                    CustomToolBar(title: "Konuşma Başlat",icon: nil,action: nil,userImageURL: "",hasUserImage: false,titleAlignment: .center,textAction: {
                        
                    },paddingSize: 125)
                        .padding(.bottom,20)
                    ScrollView{
                        VStack(spacing: 35){
                            if let matchedUser = matchedUser {
                                FeedbackCard( profileImageURL: matchedUser.profileImageURL, name: matchedUser.username, role:"Dinelyici",
                                              rating: 0,feedbackText: matchedUser.about ?? "Henüz hakkında bilgi yok.")
                                
                                .onAppear{
                                    viewModel.fetchFeedbacks(for: matchedUser.id)
                                }
                                VStack(alignment: .leading, spacing: 15){
                                    TextStyles.subtitleMedium("Geribildirimler:")
                                    if !viewModel.feedbacks.isEmpty{
                                        ForEach(viewModel.feedbacks){ feedback in
                                            FeedbackCard(profileImageURL: feedback.profileImage,name: feedback.username, role: feedback.role,rating: feedback.rating,
                                                         feedbackText:feedback.feedbackText )
                                        }
                                    }else{
                                        TextStyles.subtitleMedium2("Kullanıcının geribildirim değerlendirmesi bulunmamaktadır!")
                                    }
                                }
                            }else {
                                TextStyles.subtitleMedium("Şimdilik eşleşen kullanıcı bulunmamaktadır. Daha sonra tekrar deneyiniz.")
                                    .multilineTextAlignment(.center)
                                    .lineLimit(nil)
                            }
                           // .padding(.top,150)
                        }
                    }
                    HStack(spacing: 80){
                        CustomButton(title: Constants.TextConstants.cancel, width: 123, height: 35, backgroundColor: Color.white, borderColor: Color.primaryColor, textcolor: Color.primaryColor, action: {
                            navigateToAccept = true
                            showBottomTabBar = true
                        },
                                     font: .custom("SFPro-Display-Medium", size: 10))
                        
                        CustomButton(title: Constants.TextConstants.accept, width: 123, height: 35, backgroundColor: Color.primaryColor, borderColor: Color.primaryColor, textcolor: Color.white, action: {
                            if let matchedUser = matchedUser{
                                viewModel.startChat(with: matchedUser, currentUser: appState.currentUser!,topic: topic)
                            }
                            navigateToAccept = true
                          
                            showBottomTabBar = true
                        }, font: .custom("SFPro-Display-Medium",size: 10))
                      
                    }
                    .padding(.bottom,30)
                    
                }
            }
            .navigationDestination(isPresented: $navigateToAccept) {
                HomeView(showBottomTabBar: $showBottomTabBar, appState: appState)
                    onDisappear {
                        showBottomTabBar = true
                    }
                    .navigationBarBackButtonHidden(true)
            }

        }
   
    }
}

/*#Preview {
 SelectConversationView()
 }*/
