import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore

final class EditProfileViewModel: ObservableObject {
    @Published var user: User
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
    var appState: AppState
    
    init(appState: AppState) {
        self.appState = appState
        if let currentUser = appState.currentUser {
            self.user = currentUser
        } else {
            self.user = User(id: "", username: "", email: "", age: "", password: "", about: nil, profileImageURL: nil)
        }
    }
    
    // MARK: - Profil Resmi Yükleme
    
    func uploadProfileImage(_ image: UIImage, completion: @escaping (Bool) -> Void) {
        let storageRef = Storage.storage().reference().child("profile_images/\(UUID().uuidString).jpg")
        guard let imageData = image.jpegData(compressionQuality: 0.8) else { return }
        
        storageRef.putData(imageData, metadata: nil) { [weak self] _, error in
            if let error = error {
                self?.errorMessage = "Resim yüklenirken hata oluştu: \(error.localizedDescription)"
                completion(false)
                return
            }
            storageRef.downloadURL { url, error in
                if let url = url {
                    // URL'yi hem Firestore'a kaydediyoruz hem de appState'e güncelliyoruz
                    self?.user.profileImageURL = url.absoluteString
                    self?.saveProfileImageURL(url.absoluteString)
                    completion(true)
                } else {
                    self?.errorMessage = "Resim URL'si alınırken hata oluştu"
                    completion(false)
                }
            }
        }
    }

    private func saveProfileImageURL(_ url: String) {
        let db = Firestore.firestore()
        guard let userID = Auth.auth().currentUser?.uid else { return }
        
        // Firestore'da güncelleme
        db.collection("users").document(userID).updateData(["profileImageURL": url]) { error in
            if let error = error {
                print("Firestore güncellemesi başarısız: \(error.localizedDescription)")
            } else {
                // Firebase Firestore güncellenince appState'e de güncelleme yapıyoruz
                DispatchQueue.main.async {
                    self.appState.currentUser?.profileImageURL = url
                    print("Yeni profil resmi URL'si: \(String(describing: self.appState.currentUser?.profileImageURL))")
                }
            }
        }
    }

    
    
    // MARK: - E-mail Güncelleme
    
    func updateUserProfile(updateEmail: Bool, updatePassword: Bool, newEmail: String, newPassword: String, currentPassword: String, completion: @escaping (Bool) -> Void) {
        isLoading = true
        
        if updateEmail {
            // E-posta güncellemesi
            AuthenticationManager.shared.updateEmail(newEmail: newEmail, currentPassword: currentPassword) { success, errorMessage in
                if success {
                    self.user.email = newEmail
                    self.checkPasswordUpdate(updatePassword: updatePassword, newPassword: newPassword, currentPassword: currentPassword, completion: completion)
                } else {
                    self.errorMessage = errorMessage
                    completion(false)
                    self.isLoading = false
                }
            }
        } else {
            // Şifre güncellemesini kontrol et
            checkPasswordUpdate(updatePassword: updatePassword, newPassword: newPassword, currentPassword: currentPassword, completion: completion)
        }
    }    
    // Şifre güncelleme cehck
    private func checkPasswordUpdate(updatePassword: Bool, newPassword: String, currentPassword: String, completion: @escaping (Bool) -> Void) {
        if updatePassword {
            AuthenticationManager.shared.updatePassword(newPassword: newPassword, currentPassword: currentPassword) { success, errorMessage in
                if success {
                    print("güncelledim")
                    self.updateFirestoreProfile(userID: Auth.auth().currentUser?.uid ?? "", completion: completion)
                } else {
                    self.errorMessage = errorMessage
                    print("güncellenemedim: \(String(describing: errorMessage))")
                    completion(false)
                    self.isLoading = false
                }
            }
        }
        self.updateFirestoreProfile(userID: Auth.auth().currentUser?.uid ?? "", completion: completion)
    }

    
    private func updateFirestoreProfile(userID: String, completion: @escaping (Bool) -> Void) {
        let db = Firestore.firestore()
        db.collection("users").document(userID).updateData([
            "username": user.username,
            "email": user.email,
            "age": user.age,
            "password": user.password,
            "about": user.about ?? "Henüz hakkında bilgisi yok",
            "profileImageURL": user.profileImageURL ?? ""
        ]) { error in
            if let error = error {
                self.errorMessage = "Firestore güncellemesi başarısız: \(error.localizedDescription)"
                completion(false)
            } else {
                self.appState.currentUser = self.user
                completion(true)
            }
        }
    }
}
