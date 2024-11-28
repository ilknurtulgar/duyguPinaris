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
                                            appState.selectedTab = "Home"
                                        }else{
                                            isRegistering = false
                                        }
                                    }},font: .custom("SFPro-Display-Medium", size: 15))
                        .padding(.top, 65)
                        .navigationDestination(isPresented: $isRegistering) {
                            HomeView(appState: appState, showBottomTabBar: $showBottomTabBar)
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
                            LoginView(showBottomTabBar: $showBottomTabBar)
                                .navigationBarHidden(true)
                        }
                    }
                }
            }
        }
    }
}

/*#Preview {
 RegisterView()
 }*/
