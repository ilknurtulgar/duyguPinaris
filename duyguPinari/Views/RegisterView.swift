//
//  RegisterView.swift
//  duyguPinari
//
//  Created by İlknur Tulgar on 5.11.2024.
//

import SwiftUI
import FirebaseAuth

struct RegisterView: View {
    
    @StateObject private var viewModel = RegisterViewModel()
    @State private var isRegistering = false
    @Binding var showBottomTabBar: Bool
    @State private var isNavigatingToLogin = false
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.backgroundPrimary
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack {
                        AuthTitle(title: RegisterViewModel.RegisterConstants.sign, subtitle: RegisterViewModel.RegisterConstants.signUp)
                        
                        CustomTextField( text: $viewModel.user.username,placeholder: Constants.TextConstants.placeholderUsername, subtitle:Constants.TextConstants.usernameTitle)
                        CustomTextField(text: $viewModel.user.email,placeholder: Constants.TextConstants.placeholderEmail,  subtitle: Constants.TextConstants.emailTitle)
                        CustomTextField( text: $viewModel.user.age,placeholder: Constants.TextConstants.placeholderAge, subtitle: Constants.TextConstants.ageTitle)
                        CustomTextField(text: $viewModel.user.password, placeholder: Constants.TextConstants.placeholderPassword, isSecure: true, subtitle: Constants.TextConstants.passwordTitle)
                        if let errorMessage = viewModel.errorMessage{
                            Text(errorMessage)
                                .foregroundStyle(.red)
                        }
                        TextStyles.subtitleRegular("*Şifreyi en az 6 karakter şeklinde giriniz\n*Kayıt olduktan sonra uygulamayı kullanabilmek için e mail adresinize gönderilecek olan doğrulamayı onaylayınız.")
                            .foregroundStyle(Color.textColor)
                            .multilineTextAlignment(.center)
                            .padding(.top,5)
                        
                        CustomButton(
                            title: Constants.TextConstants.signup,
                            width: 295,
                            height: 40,
                            backgroundColor: Color.primaryColor,
                            borderColor: Color.primaryColor,
                            textcolor: .white,
                            action:
                                {
                                    viewModel.registerUser{ success, _ in
                                        if success{
                                            isRegistering = true
                                            showBottomTabBar = true
                                            appState.isLoggedIn = true
                                            appState.fetchUserProfile()
                                            sendEmailVerification()
                                        }else{
                                            isRegistering = false
                                        }
                                    }},font: .custom("SFPro-Display-Medium", size: 15))
                        .padding(.top, 65)
                        .navigationDestination(isPresented: $isRegistering) {
                            HomeView( showBottomTabBar: $showBottomTabBar, appState: appState)
                                .environmentObject(appState)
                                .navigationBarHidden(true)
                        }
                        self.withHorizontalLinesAndText(Constants.TextConstants.or)
                        CustomButton(
                            title: Constants.TextConstants.signin,
                            width: 295,
                            height: 40,
                            backgroundColor: Color.white,
                            borderColor: Color.primaryColor,
                            textcolor: .primaryColor,
                            action:
                                {
                                    isNavigatingToLogin = true
                                },
                            font: .custom("SFPro-Display-Medium", size: 15))
                        .padding(.top, 15)
                        .navigationDestination(isPresented: $isNavigatingToLogin) {
                            LoginView(appState: appState,showBottomTabBar: $showBottomTabBar)
                                .navigationBarHidden(true)
                        }
                    }
                }
            }
        }
    }
    private func sendEmailVerification(){
        Auth.auth().currentUser?.sendEmailVerification{error in
            if error != nil {
        print("doğrulama gönderdim")
              
            }else {
            print("gönderemedim")
            }
        }
    }
}

/*#Preview {
 RegisterView()
 }*/
