//
//  AddFeedbackView.swift
//  duyguPinari
//
//  Created by İlknur Tulgar on 3.12.2024.
//

import SwiftUI

struct AddFeedbackView: View {
    @State private var feedbackText: String = ""
    @State private var rating: Int = 0
    @State var isState: Bool = false
    @EnvironmentObject var appState: AppState
    @Binding var showBottomTabBar: Bool
    @State private var showAlert: Bool = false
    @StateObject var viewModel = AddFeedbackViewModel()
   
    var chatUser: ChatUser
    var body: some View {
        NavigationStack {
            ZStack {
                Color.backgroundPrimary.ignoresSafeArea()
                
                VStack(spacing: 0) {
                    CustomToolBar(
                        title: "matchedUserName",
                        icon: Image(systemName: "chevron.left"),
                        action: {
                            showAlert = true
                        },
                        userImageURL: "",
                        hasUserImage: true,
                        titleAlignment: .leading,
                        textAction: nil,
                        paddingSize: 10
                    )
                    
                    ScrollView { // Kaydırılabilir alan
                        VStack(alignment: .leading, spacing: 15) {
                            TextStyles.subtitleMedium2("Puanlama:")
                                .padding(.leading, 70)
                            RatingView(rating: $rating) // Yıldız Derecelendirme
                                .padding(.leading, 70)
                                .padding(.top, 10)
                                .padding(.bottom,30)
                            TextStyles.subtitleMedium2("Sohbet nasıl geçti:")
                                .padding(.leading, 70)
                            
                            TextStyles.subtitleMedium2("(İsteğe bağlı )")
                                .padding(.leading, 70)
                            
                            CustomTextField(
                                text: $feedbackText,
                                placeholder: "Görüşlerinizi buraya yazın",
                                isAbout: true
                            )
                            .padding(.horizontal, 70)
                            if let errorMessage = viewModel.errorMessage {
                                Text(errorMessage)
                                    .foregroundColor(.red)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal, 40)
                            }
                        }
                        .padding(.top, 20)
                    }
                  
                    Spacer()
                    
                    CustomButton(
                        title: "Onayla",
                        width: 295,
                        height: 40,
                        backgroundColor: Color.primaryColor,
                        borderColor: Color.primaryColor,
                        textcolor: Color.white,
                        action: {
                            let feedback = Feedback(id: UUID().uuidString, receiverID: chatUser.id, senderID: appState.currentUser?.id ?? "", username: chatUser.username, role: chatUser.role ?? "yokum", rating: rating, feedbackText: feedbackText)
                            viewModel.addFeedbackAndDeleteChat(feedback: feedback, currentUserId: appState.currentUser?.id ?? "", chatUserId: chatUser.id){ success in
                                if success {
                                    isState = true
                                    showBottomTabBar = true
                                }
                            }
                            
                          //  print("Rating: \(rating), Feedback: \(feedbackText)")
                        },
                        font: .custom("SFPro-Display-Medium", size: 15)
                    )
                    .padding(.bottom, 30)
                }
                .navigationDestination(isPresented: $isState){
                    HomeView(showBottomTabBar: $showBottomTabBar, appState: appState)
                        .environmentObject(appState)
                        .navigationBarBackButtonHidden(true)
                        .onDisappear{
                            appState.homeViewModel?.fetchChatUsers(for: appState.currentUser?.id ?? ""){
                            }
                            isState = false
                           
                        }
                    
                }
                .alert("Geri Bildirim Verme", isPresented: $showAlert) {
                    Button("Hayır", role: .cancel) { }
                    Button("Evet") {
                        viewModel.deleteChatData(
                            currentUserId: appState.currentUser?.id ?? "",
                            chatUserId: chatUser.id
                        ) { success in
                            if success {
                             
                                showBottomTabBar = true
                                isState = true
                            }
                        }
                    }
                } message: {
                    Text("Geri dönerseniz geri bildiriminiz iptal olacaktır. Onaylıyor musunuz?")
                }
            }
        }
    }
}

/*#Preview {
 AddFeedbackView()
 }*/
