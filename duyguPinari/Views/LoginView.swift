//
//  LoginView.swift
//  duyguPinari
//
//  Created by İlknur Tulgar on 4.11.2024.
//

import SwiftUI

struct LoginView: View {
    @State private var isNavigatingToHome = false
    @State private var isNavigatingToRegister = false
    @StateObject private var viewModel = LoginViewModel()
    @EnvironmentObject var appState: AppState
    @Binding var showBottomTabBar: Bool
    
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
                        if let errorMessage = viewModel.errorMessage{
                            Text(errorMessage)
                                .foregroundStyle(.red)
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
                                        appState.isLoggedIn = true
                                        showBottomTabBar = true
                                        isNavigatingToHome = true
                                    }
                                   }},
                            font: .custom("SFPro-Display-Medium", size: 15))
                        
                        .padding(.top, 65)
                        .navigationDestination(isPresented: $isNavigatingToHome) {
                            HomeView(showBottomTabBar: $showBottomTabBar)
                                .navigationBarHidden(true) // Üst çubuğu gizle
                            
                        }
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
                        .navigationDestination(isPresented: $isNavigatingToRegister) {
                            RegisterView(showBottomTabBar: $showBottomTabBar)
                                .navigationBarHidden(true)
                        }
                    }
                }
            }
        }
    }
}

/*#Preview {
 LoginView(isLoggedIn: .constant(false))
 }*/

