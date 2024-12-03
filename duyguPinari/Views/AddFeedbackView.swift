//
//  AddFeedbackView.swift
//  duyguPinari
//
//  Created by İlknur Tulgar on 3.12.2024.
//

import SwiftUI

struct AddFeedbackView: View {
    @State private var feedbackText: String = ""
    @Environment(\.dismiss) private var dismiss
    @State private var rating: Int = 0
    @State var isState: Bool = false
    @EnvironmentObject var appState: AppState
    @Binding var showBottomTabBar: Bool
    @State private var showAlert: Bool = false
    var body: some View {
        NavigationStack {
            ZStack {
                Color.backgroundPrimary.ignoresSafeArea()
                
                VStack(spacing: 0) {
                    CustomToolBar(
                        title: "matchedUserName",
                        icon: Image(systemName: "chevron.left"),
                        action: {
                            dismiss()
                        },
                        userImageURL: "",
                        hasUserImage: true,
                        titleAlignment: .leading,
                        textAction: nil,
                        paddingSize: 10
                    )
                    
                    ScrollView { // Kaydırılabilir alan
                        VStack(alignment: .leading, spacing: 15) {
                            TextStyles.subtitleMedium2("Skor:")
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
                            showAlert = true
                            print("Rating: \(rating), Feedback: \(feedbackText)")
                        },
                        font: .custom("SFPro-Display-Medium", size: 15)
                    )
                    .padding(.bottom, 30)
                }
               .navigationDestination(isPresented: $isState){
                  HomeView(showBottomTabBar: $showBottomTabBar, appState: appState)
                        .navigationBarBackButtonHidden(true)
                      
            
                }
                .alert("Geri Bildirim Verme", isPresented: $showAlert) {
                    Button("Hayır", role: .cancel) { }
                    Button("Evet") {
                    isState = true
                        showBottomTabBar = true
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
