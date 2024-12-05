//
//  EditProfileViewModel.swift
//  duyguPinari
//
//  Created by İlknur Tulgar on 27.11.2024.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage

class EditProfileViewModel: ObservableObject {
    @Published var user: User
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
    private var appState: AppState
    
    init(appState: AppState) {
        self.appState = appState
        if let currentUser = appState.currentUser {
            self.user = currentUser
        } else {
            self.user = User(id: "", username: "", email: "", age: "", password: "", about: nil, profileImageURL: "")
        }
    }
    
    func uploadProfileImage(_ image: UIImage) {
        let storage = Storage.storage()
        let storageRef = storage.reference().child("profile_images/\(UUID().uuidString).jpg")
        
        if let imageData = image.jpegData(compressionQuality: 0.8) {
            storageRef.putData(imageData, metadata: nil) { [weak self] _, error in
                if let error = error {
                    self?.errorMessage = "Error uploading image: \(error.localizedDescription)"
                    print(self?.errorMessage ?? "")
                    return
                }
                storageRef.downloadURL { url, error in
                    if let error = error {
                        self?.errorMessage = "Error fetching image URL: \(error.localizedDescription)"
                        print(self?.errorMessage ?? "")
                        return
                    }
                    if let url = url {
                        self?.user.profileImageURL = url.absoluteString
                        self?.saveProfileImageURL(url.absoluteString)
                    }
                }
            }
        }
    }
    
    func saveProfileImageURL(_ url: String) {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        let db = Firestore.firestore()
        db.collection("users").document(userID).updateData(["profileImageURL": url]) { error in
            if let error = error {
                self.errorMessage = "Error updating Firestore with image URL: \(error.localizedDescription)"
                print(self.errorMessage ?? "")
            } else {
                print("Profile image URL saved to Firestore successfully.")
            }
        }
    }
    
    func updateUserProfile(userPassword: String) {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        guard let currentUser = Auth.auth().currentUser else { return }
        
        self.isLoading = true
        
        // Yeniden kimlik doğrulama
        let credential = EmailAuthProvider.credential(withEmail: currentUser.email ?? "", password: userPassword)
        currentUser.reauthenticate(with: credential) { [weak self] _, error in
            if let error = error {
                self?.isLoading = false
                self?.errorMessage = "Reauthentication failed: \(error.localizedDescription)"
                print(self?.errorMessage ?? "")
                return
            }
            
            // E-posta güncelleme işlemi
            currentUser.updateEmail(to: self?.user.email ?? "") { [weak self] error in
                if let error = error {
                    self?.isLoading = false
                    self?.errorMessage = "Error updating email: \(error.localizedDescription)"
                    print(self?.errorMessage ?? "")
                    return
                }
                
                // E-posta doğrulama linki gönder
                currentUser.sendEmailVerification { error in
                    if let error = error {
                        self?.isLoading = false
                        self?.errorMessage = "Error sending email verification: \(error.localizedDescription)"
                        print(self?.errorMessage ?? "")
                        return
                    }
                    print("Verification email sent successfully.")
                    
                    // Kullanıcı doğrulamayı yaptıktan sonra Firestore profilini güncelle
                    self?.updateFirestoreProfile(userID: userID)
                }
            }
        }
    }
    
    private func updateFirestoreProfile(userID: String) {
        let db = Firestore.firestore()
        db.collection("users").document(userID).updateData([
            "username": self.user.username,
            "email": self.user.email,
            "age": self.user.age,
            "about": self.user.about ?? "",
            "profileImageURL": self.user.profileImageURL ?? ""
        ]) { [weak self] error in
            self?.isLoading = false
            if let error = error {
                self?.errorMessage = "Error updating Firestore profile: \(error.localizedDescription)"
                print(self?.errorMessage ?? "")
            } else {
                // Firestore'da işlem başarılıysa appState'i güncelle
                self?.appState.currentUser = self?.user
                print("Profile updated in Firestore successfully.")
            }
        }
    }
}





