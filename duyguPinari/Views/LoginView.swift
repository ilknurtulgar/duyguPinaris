//
//  LoginView.swift
//  duyguPinari
//
//  Created by İlknur Tulgar on 4.11.2024.
//

import SwiftUI

struct LoginView: View {
    @Binding var isLoggedIn: Bool
    @State private var isNavigatingToHome = false
    @State private var isNavigatingToRegister = false
    @StateObject private var viewModel = LoginViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.backgroundPrimary
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack {
                        AuthTitle(title: "GİRİŞ", subtitle: "YAP")
                        
                        CustomTextField(text: $viewModel.email,placeholder: "alara@example.com",  subtitle: "E mail:")
                        CustomTextField(text: $viewModel.password,placeholder: "******",  isSecure: true, subtitle: "Şifre:")
                        if let errorMessage = viewModel.errorMessage{
                            Text(errorMessage)
                                .foregroundStyle(.red)
                        }
                        
                        Spacer()
                        CustomButton(
                            title: "Giriş Yap",
                            backgroundColor: Color.primaryColor,
                            borderColor: Color.primaryColor,
                            textcolor: .white
                        ) {
                            if viewModel.loginUser(){
                                isNavigatingToHome = true
                                isLoggedIn=true
                            }else{
                                isLoggedIn = false
                            }
                            
                           
                        }
                        .padding(.top, 65)
                        .navigationDestination(isPresented: $isNavigatingToHome) {
                            HomeView()
                                .navigationBarHidden(true) // Üst çubuğu gizle
                         
                        }
                        self.withHorizontalLinesAndText("YA DA")
                        
                        CustomButton(
                            title: "Kayıt Ol",
                            backgroundColor: Color.white,
                            borderColor: Color.primaryColor,
                            textcolor: .primaryColor
                        ) {
                            isNavigatingToRegister = true
                        }
                        .padding(.top, 15)
                        .navigationDestination(isPresented: $isNavigatingToRegister) {
                            RegisterView()
                                .navigationBarHidden(true) // Üst çubuğu gizle
                        }
                    }
                }
                .padding(.top)
            }
        }
        .navigationBarHidden(true) // LoginView için de üst çubuğu gizle
    }
}


#Preview {
    LoginView(isLoggedIn: .constant(false))
}

