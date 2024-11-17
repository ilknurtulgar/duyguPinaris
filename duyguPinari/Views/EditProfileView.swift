//
//  EditProfileView.swift
//  duyguPinari
//
//  Created by İlknur Tulgar on 14.11.2024.
//

import SwiftUI

struct EditProfileView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var showBottomTabBar: Bool
    @State private var username: String = "alexa"
    @State private var email: String = "alexa@example.com"
    @State private var age: String = "15.10.1997"
    @State private var about: String = "sacdcdövdöşwedbwsüdflçöeğrldfacdcdövdöşwedbwsüdflçöeğrldfacdcdövdöşwedbwsüdflçöeğrldfacdcdövdöşwedbwsüdflçöeğrldfacdcdövdöşwedbwsüdflçöeğrldfacdcdövdöşwedbwsüdflçöeğrldfacdcdövdöşwedbwsüdflçöeğrldf"
    
    var body: some View {
        ZStack {
            Color.backgroundPrimary.ignoresSafeArea()
            VStack(spacing: 0) {
                CustomToolBar(title: "Profil Düzenleme", icon: Image(systemName: "chevron.left")) {
                    dismiss()
                }
                
                ScrollView {
                    VStack(spacing: 16) {
                        ProfileImage()
                            .padding(.top, 16)
                        CustomTextField(text: $username, placeholder: "Alexa Richardson", subtitle: "UserName:")
                        CustomTextField(text: $email, placeholder: "alexa@example.com", subtitle: "E mail:")
                        CustomTextField(text: $age, placeholder: "15.10.1997", subtitle: "Age:")
                        CustomTextField(text: $about, placeholder: "Alexa Richardson", isAbout: true, subtitle: "About:")
                        
                        HStack(spacing: 68) {
                            CustomButton(
                                title: Constants.TextConstants.cancel,
                                width: 123,
                                height: 35,
                                backgroundColor: Color.white,
                                borderColor: Color.primaryColor,
                                textcolor: Color.primaryColor,
                                action: {
                                    dismiss()
                                },
                                font: .custom("SFPro-Display-Medium", size: 10)
                            )
                            CustomButton(
                                title: Constants.TextConstants.accept,
                                width: 123,
                                height: 35,
                                backgroundColor: Color.primaryColor,
                                borderColor: Color.primaryColor,
                                textcolor: Color.white,
                                action: {
                                    print("here")
                                },
                                font: .custom("SFPro-Display-Medium", size: 10)
                            )
                        }
                        .padding(.top, 24)
                        .padding(.bottom, 40)
                       
                    }
                    
                }
                .padding(.horizontal, 16)
            }
            .padding(.top)
        }
  
    }
}




/*#Preview {
 EditProfileView()
 }*/

