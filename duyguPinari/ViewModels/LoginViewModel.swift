//
//  LoginViewModel.swift
//  duyguPinari
//
//  Created by İlknur Tulgar on 17.11.2024.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

class LoginViewModel: ObservableObject {
    @Published var errorMessage: String?
    @Published var user = User(id: "", username: "", email: "", age: "", password: "")
    
    var appState: AppState
    
    init(appState: AppState) {
        self.appState = appState
    }
    
    private func translateFirebaseError(_ error: Error) -> String {
        let errorCode = (error as NSError).code
        switch errorCode {
        case AuthErrorCode.invalidEmail.rawValue:
            return "Geçersiz e-posta adresi girdiniz."
        case AuthErrorCode.userNotFound.rawValue:
            return "Kullanıcı bulunamadı. Lütfen kayıt olun."
        case AuthErrorCode.wrongPassword.rawValue:
            return "Şifre hatalı. Lütfen tekrar deneyin."
        case AuthErrorCode.networkError.rawValue:
            return "Ağ bağlantısı hatası. Lütfen internetinizi kontrol edin."
        case AuthErrorCode.emailAlreadyInUse.rawValue:
            return "Bu e-posta adresi zaten kullanımda."
        default:
            return "E posta veya şifre hatalı."
        }
    }
    
    struct LoginConstants {
        static let sign = "GİRİŞ"
        static let signIn = "YAP"
    }
    
    func loginUser(completion: @escaping (Bool) -> Void) {
        guard !user.email.isEmpty else {
            errorMessage = "Lütfen e-posta adresinizi girin."
            completion(false)
            return
        }
        
        guard isValidEmail(user.email) else  {
            errorMessage = Constants.TextConstants.unvalidEmail
            completion(false)
            return
        }
        
        guard !user.password.isEmpty else {
            errorMessage = Constants.TextConstants.emptyPassword
            completion(false)
            return
        }
        
        Auth.auth().signIn(withEmail: user.email, password: user.password) { [weak self] authResult, error in
            if let error = error {
                self?.errorMessage = self?.translateFirebaseError(error)
                completion(false)
                return
            }
            
            if let userId = authResult?.user.uid {
                
                
                DispatchQueue.main.async {
                    self?.appState.currentUser = User(id: userId,
                                                      username: self?.user.username ?? "",
                                                      email: self?.user.email ?? "",
                                                      age: self?.user.age ?? "",
                                                      password: self?.user.password ?? "")
                    self?.appState.isLoggedIn = true
                    self?.appState.selectedTab = "Home" // Login olduktan sonra ana sayfayı seç
                    
                    self?.syncPasswordToFirestore { success, message in
                        if !success {
                            self?.errorMessage = message
                        }
                        completion(true)
                    }
                }
            }
        }
    }
    
    func syncPasswordToFirestore(completion: @escaping (Bool, String?) -> Void) {
        guard let currentUser = Auth.auth().currentUser else {
            completion(false, "Kullanıcı oturum açmamış.")
            return
        }
        
        let userId = currentUser.uid
        let newPassword = user.password
        
        guard !newPassword.isEmpty else {
            completion(false, "Şifre alanı boş olamaz.")
            return
        }
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(userId)
        
        userRef.updateData(["password":newPassword]){error in
            if let error = error {
                completion(false, "Firestore güncelleme hatası: \(error.localizedDescription)")
            } else {
                completion(true, "Şifre başarıyla Firestore'da güncellendi.")
            }
        }
    }
    
    func resetPassword(for email: String,completion: @escaping (Bool,String?) -> Void){
        guard isValidEmail(email)else{
            completion(false,"Geçersiz e mail adresi.")
            return
        }
        Auth.auth().sendPasswordReset(withEmail: email){
            error in
            if let error = error {
                let errorMessage = self.translateFirebaseError(error)
                completion(false,errorMessage)
            }else{
                completion(true,"Şifre sıfırlama e maili gönderildi.")
            }
        }
        
    }
    
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailTest.evaluate(with: email)
    }
}
