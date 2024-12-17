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
        db.collection("users").document(userID).updateData(["profileImageURL": url])
    }
    
    
    // MARK: - E-mail Güncelleme
    
    func updateUserProfile(updateEmail: Bool, newEmail: String, currentPassword: String, completion: @escaping (Bool) -> Void) {
        isLoading = true
        
        if updateEmail {
            // E-posta güncelleniyor, önce kullanıcıyı yeniden kimlik doğrulama yap
                    AuthenticationManager.shared.updateEmail(newEmail: newEmail,currentPassword: currentPassword) { success, errorMessage in
                        if success {
                            // E-posta başarılı şekilde güncellendiyse, Firestore'da güncelleme yapılacak
                            self.user.email = newEmail
                            print("atanan e mail: \(self.user.email)")
                            print("ıd: \(self.user.id)")
                            self.updateFirestoreProfile(userID: Auth.auth().currentUser?.uid ?? "", completion: completion)
                        } else {
                            self.errorMessage = errorMessage
                            print("hata var : \(String(describing: self.errorMessage))")
                            completion(false)
                        }
                        self.isLoading = false
                    }
                }
         else {
            updateFirestoreProfile(userID: Auth.auth().currentUser?.uid ?? "", completion: completion)
        }
    }
    
    private func updateFirestoreProfile(userID: String, completion: @escaping (Bool) -> Void) {
        let db = Firestore.firestore()
        print("gelenID: \(userID)")
        db.collection("users").document(userID).updateData([
            "username": user.username,
            "email": user.email,
            "age": user.age,
            "about": user.about ?? "",
            "profileImageURL": user.profileImageURL ?? ""
        ]) { error in
            if let error = error {
                self.errorMessage = "Firestore güncellemesi başarısız: \(error.localizedDescription)"
                completion(false)
            } else {
                // Güncellenen kullanıcıyı appState'e kaydet
                self.appState.currentUser = self.user
                completion(true)
            }
        }
    }
}
