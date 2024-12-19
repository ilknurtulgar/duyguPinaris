//
//  LoginView.swift
//  duyguPinari
//
//  Created by İlknur Tulgar on 4.11.2024.
//

import SwiftUI

struct LoginView: View {
    @State private var isNavigatingToHome = false
    @State private var showResetPasswordAlert = false
    @State private var resetEmail = ""
    @State private var resetPasswordMessage = ""
    @State private var isResetSuccessful = false
    @State private var isNavigatingToRegister = false
    @StateObject private var viewModel: LoginViewModel
    @ObservedObject var appState: AppState
    @Binding var showBottomTabBar: Bool
    
    init(appState: AppState, showBottomTabBar: Binding<Bool>) {
        _viewModel = StateObject(wrappedValue: LoginViewModel(appState: appState))
        self.appState = appState
        _showBottomTabBar = showBottomTabBar
    }
    
    var body: some View {
        NavigationStack{
            ZStack {
                Color.backgroundPrimary
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack {
                        AuthTitle(title:LoginViewModel.LoginConstants.sign, subtitle: LoginViewModel.LoginConstants.signIn)
                        
                        CustomTextField(text: $viewModel.user.email,placeholder: Constants.TextConstants.placeholderEmail,  subtitle: Constants.TextConstants.emailTitle)
                        CustomTextField(text: $viewModel.user.password,placeholder: Constants.TextConstants.placeholderPassword,  isSecure: true, subtitle: Constants.TextConstants.passwordTitle)
                        Button(action:{
                            showResetPasswordAlert = true
                        }){
                            TextStyles.bodyRegular("Şifrenizi mi unuttunuz?")
                                .padding(.leading,200)
                        }
                        if let errorMessage = viewModel.errorMessage{
                            Text(errorMessage)
                                .foregroundStyle(.red)
                                .padding(.top,10)
                        }
                        CustomButton(
                            title: Constants.TextConstants.signin,
                            width: 295,
                            height: 40,
                            backgroundColor: Color.primaryColor,
                            borderColor: Color.primaryColor,
                            textcolor: .white,
                            action: {
                                
                                viewModel.loginUser { success in
                                    if success{
                                        print("girdim")
                                        appState.isLoggedIn = true
                                        showBottomTabBar = true
                                        isNavigatingToHome = true
                                        appState.fetchUserProfile()
                                        
                                        
                                    }
                                }},
                            font: .custom("SFPro-Display-Medium", size: 15))
                        .padding(.top, 35)
                        
                        self.withHorizontalLinesAndText(Constants.TextConstants.or)
                        
                        CustomButton(
                            title: Constants.TextConstants.signup,
                            width: 295,
                            height: 40,
                            backgroundColor: Color.white,
                            borderColor: Color.primaryColor,
                            textcolor: .primaryColor,
                            action:{
                                isNavigatingToRegister = true
                                
                            },
                            font:.custom("SFPro-Display-Medium", size: 15))
                        
                        .padding(.top, 15)
                        
                        
                    }
                }
                
            }
            .navigationDestination(isPresented: $isNavigatingToHome) {
                HomeView( showBottomTabBar: $showBottomTabBar, appState: appState)
                    .navigationBarHidden(true) // Üst çubuğu gizle
                
            }
            .navigationDestination(isPresented: $isNavigatingToRegister) {
                RegisterView(showBottomTabBar: $showBottomTabBar)
                    .environmentObject(appState)
                    .navigationBarHidden(true)
                
            }
            .alert("Şifre Sıfırlama", isPresented: $showResetPasswordAlert, actions: {
                TextField("E-posta adresinizi girin", text: $resetEmail)
                   
                    .textInputAutocapitalization(.never)
                    .keyboardType(.emailAddress)
                
                Button("Gönder") {
                    viewModel.resetPassword(for: resetEmail) { success, message in
                        isResetSuccessful = success
                        resetPasswordMessage = message ?? ""
                    }
                }
                
                Button("İptal", role: .cancel) {}
            }, message: {
                Text("Gönder butonuna tıkladıktan sonra e mail adresinizi kontrol ediniz. \(resetPasswordMessage)")
            })
            
        }
    }
}

/*#Preview {
 LoginView(isLoggedIn: .constant(false))
 }*/

