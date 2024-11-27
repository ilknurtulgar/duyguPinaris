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
    @StateObject private var viewModel: EditProfileViewModel
    @State private var showAlert: Bool = false
    
    init(appState: AppState, showBottomTabBar: Binding<Bool>) {
        _viewModel = StateObject(wrappedValue: EditProfileViewModel(appState: appState))
        _showBottomTabBar = showBottomTabBar
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color.backgroundPrimary
                    .ignoresSafeArea()
                VStack(spacing: 0) {
                    CustomToolBar(title: "Profil Düzenleme", icon: Image(systemName: "chevron.left")) {
                        dismiss()
                        showBottomTabBar = true
                    }
                    ScrollView {
                        VStack(spacing: 16) {
                            ProfileImage()
                                .padding(.top, 16)
                            CustomTextField(text: $viewModel.user.username, placeholder: "", subtitle: "UserName:")
                            CustomTextField(text: $viewModel.user.email, placeholder: "alexa@example.com", subtitle: "E mail:")
                            CustomTextField(text: $viewModel.user.password, placeholder: Constants.TextConstants.placeholderPassword, isSecure: true, subtitle: Constants.TextConstants.passwordTitle)
                            CustomTextField(text: $viewModel.user.age, placeholder: "15.10.1997", subtitle: "Age:")
                            CustomTextField(text: Binding(get: { viewModel.user.about ?? "" }, set: { viewModel.user.about = $0 }), placeholder: "Alexa Richardson", isAbout: true, subtitle: "About:")
                            
                            HStack(spacing: 68) {
                                CustomButton(
                                    title: Constants.TextConstants.cancel,
                                    width: 123,
                                    height: 35,
                                    backgroundColor: Color.white,
                                    borderColor: Color.primaryColor,
                                    textcolor: Color.primaryColor,
                                    action: {
                                        showBottomTabBar = true
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
                                       
                                        showAlert = true
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
            .alert("Profil Düzenleme", isPresented: $showAlert) {
                Button("İptal", role: .cancel) { }
                Button("Onayla") {
                    viewModel.updateUserProfile()
                    showBottomTabBar = true
                    dismiss()
                }
            } message: {
                Text("Değişiklikleri kaydetmeyi onaylıyor musunuz?")
            }
        }
    }
}





/*#Preview {
 EditProfileView()
 }*/

