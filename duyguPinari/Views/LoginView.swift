//
//  LoginView.swift
//  duyguPinari
//
//  Created by İlknur Tulgar on 4.11.2024.
//

//Vstack kullanacağım
import SwiftUI
struct LoginView: View {
    @Binding var isLoggedIn: Bool
    @State private var username = ""
    @State private var password = ""
    @State private var isNavigatingToHome = false
    @State private var isNavigatingToRegister = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.backgroundPrimary
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack {
                        AuthTitle(title: "GİRİŞ", subtitle: "YAP")
                        
                        CustomTextField(placeholder: "alara@example.com", text: $username, subtitle: "E mail:")
                        CustomTextField(placeholder: "******", text: $password, isSecure: true, subtitle: "Şifre:")
                        
                        Spacer()
                        CustomButton(
                            title: "Giriş Yap",
                            backgroundColor: Color.primaryColor,
                            borderColor: Color.primaryColor,
                            textcolor: .white
                        ) {
                            isNavigatingToHome = true
                            isLoggedIn=true
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
                    .padding()
                }
            }
        }
        .navigationBarHidden(true) // LoginView için de üst çubuğu gizle
    }
}


#Preview {
    LoginView(isLoggedIn: .constant(false))
}

