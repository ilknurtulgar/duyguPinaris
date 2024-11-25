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
    @State private var showAlert: Bool = false
    @State private var username: String = "alexa"
    @State private var email: String = "alexa@example.com"
    @State private var age: String = "15.10.1997"
    @State private var password="123"
    @State private var about: String = "sacdcdövdöşwedbwsüdflçöeğrldfacdcdövdöşwedbwsüdflçöeğrldfacdcdövdöşwedbwsüdflçöeğrldfacdcdövdöşwedbwsüdflçöeğrldfacdcdövdöşwedbwsüdflçöeğrldfacdcdövdöşwedbwsüdflçöeğrldfacdcdövdöşwedbwsüdflçöeğrldf"

    var body: some View {
        NavigationStack{
            ZStack {
                Color.backgroundPrimary
                    .ignoresSafeArea()
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
                            CustomTextField(text: $password,placeholder: Constants.TextConstants.placeholderPassword,  isSecure: true, subtitle: Constants.TextConstants.passwordTitle)
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
                                        showAlert=true
                                    },
                                    font: .custom("SFPro-Display-Medium", size: 10)
                                )
                            }
                            .padding(.top, 24)
                            .padding(.bottom, 40)
                            
                        }
                        .padding(.horizontal, 16)
                    }
                    
                }
            }
            .alert("Profil Düzenleme",isPresented: $showAlert){
                Button("İptal",role: .cancel){}
                
                Button("Onayla"){
                    dismiss()
                }
            }message: {
                Text("Değişiklikleri kaydetmeyi onaylıyor musunuz?")
            }
            
        }
    }
}




/*#Preview {
 EditProfileView()
 }*/

