//
//  RegisterView.swift
//  duyguPinari
//
//  Created by İlknur Tulgar on 5.11.2024.
//

import SwiftUI

struct RegisterView: View {
    
    @StateObject private var viewModel = RegisterViewModel()
    @State private var isRegistering = false
    @State private var isNavigatingToLogin = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.backgroundPrimary
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack {
                        AuthTitle(title: "KAYIT", subtitle: "OL")
                        
                        CustomTextField( text: $viewModel.username,placeholder: "Alara Orea", subtitle: "Kullanıcı Adı:")
                        CustomTextField(text: $viewModel.email,placeholder: "alara@example.com",  subtitle: "E mail:")
                        CustomTextField( text: $viewModel.age,placeholder: "15.11.1997", subtitle: "Yaş:")
                        CustomTextField(text: $viewModel.password, placeholder: "******", isSecure: true, subtitle: "Şifre:")
                        
                        Spacer()
                        
                        CustomButton(
                            title: "Kayıt Yap",
                            backgroundColor: Color.primaryColor,
                            borderColor: Color.primaryColor,
                            textcolor: .white
                        ) {
                            print("Kayıt Yap butonuna tıklandı!")
                            isRegistering = true
                        }
                        .padding(.top, 65)
                        .navigationDestination(isPresented: $isRegistering) {
                           HomeView()
                                .navigationBarHidden(true)
                            Color.backgroundPrimary.ignoresSafeArea()
                                .frame(width: 0,height: 0)// Üst çubuğu gizle
                        }
                        self.withHorizontalLinesAndText("YA DA")
                        CustomButton(
                            title: "Giriş Yap",
                            backgroundColor: Color.white,
                            borderColor: Color.primaryColor,
                            textcolor: .primaryColor
                        ) {
                            print("Giriş Yap butonuna tıklandı!")
                            isNavigatingToLogin = true
                        }
                        .padding(.top, 15)
                        .navigationDestination(isPresented: $isNavigatingToLogin) {
                            LoginView(isLoggedIn: .constant(false))
                                .navigationBarHidden(true) // Üst çubuğu gizle
                        }
                    }
                }
                .padding(.top)
            }
        }
        .navigationBarHidden(true) // RegisterView'de de üst çubuğu gizle
    }
}

#Preview {
    RegisterView()
}
