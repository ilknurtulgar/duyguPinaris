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
                        AuthTitle(title: RegisterViewModel.RegisterConstants.sign, subtitle: RegisterViewModel.RegisterConstants.signUp)
                        
                        CustomTextField( text: $viewModel.username,placeholder: Constants.TextConstants.placeholderUsername, subtitle:Constants.TextConstants.usernameTitle)
                        CustomTextField(text: $viewModel.email,placeholder: Constants.TextConstants.placeholderEmail,  subtitle: Constants.TextConstants.emailTitle)
                        CustomTextField( text: $viewModel.age,placeholder: Constants.TextConstants.placeholderAge, subtitle: Constants.TextConstants.ageTitle)
                        CustomTextField(text: $viewModel.password, placeholder: Constants.TextConstants.placeholderPassword, isSecure: true, subtitle: Constants.TextConstants.passwordTitle)
                        if let errorMessage = viewModel.errorMessage{
                            Text(errorMessage)
                                .foregroundStyle(.red)
                        }
                        
                        Spacer()
                        
                        CustomButton(
                            title: Constants.TextConstants.signup,
                            width: 295,
                            height: 40,
                            backgroundColor: Color.primaryColor,
                            borderColor: Color.primaryColor,
                            textcolor: .white,
                            action:
                                {
                                    if viewModel.registerUser(){
                                        isRegistering = true
                                    }else
                                    {
                                        isRegistering = false
                                    }
                                },font: .custom("SFPro-Display-Medium", size: 15))
                        .padding(.top, 65)
                        .navigationDestination(isPresented: $isRegistering) {
                            HomeView()
                                .navigationBarHidden(true)
                            Color.backgroundPrimary.ignoresSafeArea()
                                .frame(width: 0,height: 0)// Üst çubuğu gizle
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
                            LoginView(isLoggedIn: .constant(false))
                                .navigationBarHidden(true) // Üst çubuğu gizle
                        }
                    }
                }
                .padding(.top)
            }
        }
        .navigationBarHidden(true)
    }
}

#Preview {
    RegisterView()
}
