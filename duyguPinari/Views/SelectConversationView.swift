//
//  SelectConversationView.swift
//  duyguPinari
//
//  Created by İlknur Tulgar on 19.11.2024.
//

import SwiftUI

struct SelectConversationView: View {
    @State private var navigateToHomeView = false
    @State private var navigateToChatView = false
    @Environment(\.dismiss) private var dismiss
    @Binding var showBottomTabBar: Bool
    var body: some View {
        ZStack{
            Color.backgroundPrimary.ignoresSafeArea()
            VStack(spacing: 0){
                CustomToolBar(title: "Konuşma Seç",icon: nil,action: nil)
                ScrollView{
                    VStack(spacing: 35){
                        HStack{
                            TextStyles.subtitleMedium("3 kere değiştirme hakkınız bulunmakta").padding(.top,40)
                                .padding(.leading,35)
                            Button(action:{}){
                                Image(systemName: "gobackward")
                                    .foregroundColor(Color.primaryColor)
                                    .padding(.top,40)
                                    .padding(.leading,35)
                            }
                        }
                        FeedbackCard( name: "Alexa Richardson", role:"Listener", rating: 3, feedbackText:  "I'm a mobile app developer who loves creating meaningful digital experiences. Passionate about iOS development and always eager to learn new things. In my free time, I enjoy coding, reading about tech innovations, and connecting with people through creative projects.")
                        VStack(alignment: .leading,spacing: 15){
                            TextStyles.subtitleMedium2("Geribildirimler:")
                            FeedbackCard( name: "John Doe", role: "Listener", rating: 4, feedbackText: "Fantastic insights. Thank you for your support!")
                            FeedbackCard( name: "Jane Smith", role: "Listener", rating: 5, feedbackText: "Good conversation. Thanks for listening!")
                        }
                        HStack(spacing: 80){
                            CustomButton(title: Constants.TextConstants.cancel, width: 123, height: 35, backgroundColor: Color.white, borderColor: Color.primaryColor, textcolor: Color.primaryColor, action: {
                                navigateToHomeView = true
                                dismiss()
                                showBottomTabBar = true
                            },
                                     font: .custom("SFPro-Display-Medium", size: 10))
                            
                            CustomButton(title: Constants.TextConstants.accept, width: 123, height: 35, backgroundColor: Color.primaryColor, borderColor: Color.primaryColor, textcolor: Color.white, action: {navigateToChatView = true}, font: .custom("SFPro-Display-Medium",size: 10))
                        }
                        .padding(.top,85)
                        
                    }
                }
                .navigationDestination(isPresented: $navigateToChatView)
                {
                    ChatView(showBottomTabBar: $showBottomTabBar)
                        .onAppear{
                            showBottomTabBar = false
                        }
                        .onDisappear{
                            showBottomTabBar = true
                        }
                        .navigationBarBackButtonHidden(true)
                }
            }
        }
    }
}

/*#Preview {
 SelectConversationView()
 }*/
