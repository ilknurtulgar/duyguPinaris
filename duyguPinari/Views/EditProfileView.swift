//
//  EditProfileView.swift
//  duyguPinari
//
//  Created by İlknur Tulgar on 14.11.2024.
//

import SwiftUI
import FirebaseAuth

struct EditProfileView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var showBottomTabBar: Bool
    @StateObject private var viewModel: EditProfileViewModel
    @State private var showAlert: Bool = false
    @State private var isEmailUpdate: Bool = false
    @State private var isPasswordUpdate: Bool = false
    @State private var imagePath: String? = nil
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
                    CustomToolBar(
                        title: "Profil Düzenleme",
                        icon: Image(systemName: "chevron.left"),
                        action: {
                            dismiss()
                            showBottomTabBar = true
                        },
                        userImageURL: "",
                        hasUserImage: false,
                        titleAlignment: .center,
                        textAction: {},
                        paddingSize: 70
                    )
                    ScrollView {
                        VStack(spacing: 16) {
                            ProfileImagePicker(imagePath: Binding(
                                get: { imagePath ?? viewModel.user.profileImageURL ?? "" },
                                set: { newPath in
                                    imagePath = newPath
                                }
                            ))
                                .padding(.top, 16)
                            CustomTextField(text: $viewModel.user.username, placeholder: "", subtitle: "Kullanıcı Adı:")
                            CustomTextField(text: $viewModel.user.email, placeholder: "alexa@example.com", subtitle: "E mail:")
                            CustomTextField(text: $viewModel.user.password, placeholder: Constants.TextConstants.placeholderPassword, isSecure: true, subtitle: Constants.TextConstants.passwordTitle)
                            CustomTextField(text: $viewModel.user.age, placeholder: "25", subtitle: "Yaş:")
                            CustomTextField(
                                text: Binding(get: { viewModel.user.about ?? "" }, set: { viewModel.user.about = $0 }),
                                placeholder: "Alexa Richardson",
                                isAbout: true,
                                subtitle: "Hakkında:"
                            )
                            if let errorMessage = viewModel.errorMessage {
                                Text(errorMessage)
                                    .foregroundColor(.red)
                                    .font(.caption)
                                    .padding(.top,4)
                            }
                            HStack(spacing: 68) {
                                CustomButton(
                                    title: Constants.TextConstants.cancel,
                                    width: 123,
                                    height: 35,
                                    backgroundColor: Color.white,
                                    borderColor: Color.primaryColor,
                                    textcolor: Color.primaryColor,
                                    action: {
                                        // İptal butonuna tıklanınca yapılacak işlemler
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
                                        handleChanges()
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
                
                .alert("Profil Düzenleme", isPresented: $showAlert) {
                    Button("İptal", role: .cancel) {
                        // İptal butonuna tıklanınca yapılacak işlemler
                    }
                    
                    Button("Onayla") {
                      
                    saveChanges(updateEmail: isEmailUpdate,updatePassword: isPasswordUpdate)
                        
                        showBottomTabBar = true
                        dismiss()
                    }
                }
                message: {
                    Text("Değişiklikleri kaydetmeyi onaylıyor musunuz?")
                }
            }
        }
    }
  
    private func handleChanges() {
          let currentUser = viewModel.appState.currentUser
          isEmailUpdate = viewModel.user.email != currentUser?.email
          isPasswordUpdate = viewModel.user.password != currentUser?.password
          
          if let imagePath = imagePath, let imageData = try? Data(contentsOf: URL(fileURLWithPath: imagePath)), let image = UIImage(data: imageData) {
              viewModel.uploadProfileImage(image) { success in
                  if success {
                      print("Profil resmi başarıyla yüklendi")
                      showAlert = true
                  } else {
                      viewModel.errorMessage = "Profil resmi yüklenemedi."
                  }
              }
          }
          
          if isPasswordUpdate && viewModel.user.password.count < 6 {
              viewModel.errorMessage = "Şifre en az 6 karakter olmalıdır."
              showAlert = false
          } else {
              showAlert = true
          }
      }
    
    private func saveChanges(updateEmail: Bool = false,updatePassword: Bool = false) {
        viewModel.updateUserProfile(updateEmail: updateEmail, updatePassword: updatePassword, newEmail: viewModel.user.email, newPassword: viewModel.user.password, currentPassword: viewModel.appState.currentUser?.password ?? "") { success in
            if success {
                print(updateEmail ? "E-posta güncellendi" : "Profil güncellendi")
            } else {
                viewModel.errorMessage = updateEmail
                ? "E-posta güncellenirken hata oluştu."
                : "Profil güncelleme sırasında hata oluştu."
            }
        }
    }
}


/*#Preview {
 EditProfileView()
 }*/

