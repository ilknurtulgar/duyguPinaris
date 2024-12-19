//
//  RegisterViewModel.swift
//  duyguPinari
//
//  Created by İlknur Tulgar on 17.11.2024.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

class RegisterViewModel: ObservableObject {
    @Published var errorMessage: String? = nil
    @Published var user = User(id: "", username: "", email: "", age: "", password: "")
    
    struct RegisterConstants {
        static let sign = "KAYIT"
        static let signUp = "OL"
        static let usernameEmpty = "Kullanıcı adı boş"
        static let invalidAgeFormat = "Yaş formatı geçersiz. Lütfen yaşınızı giriniz."
    }
    
    func registerUser(completion: @escaping (Bool, User?) -> Void) {
        if user.username.isEmpty {
            errorMessage = RegisterConstants.usernameEmpty
            completion(false, nil)
            return
        }
        if !isValidEmail(user.email) {
            errorMessage = Constants.TextConstants.unvalidEmail
            completion(false, nil)
            return
        }
        if !isValidAge(user.age) {
            errorMessage = RegisterConstants.invalidAgeFormat
            completion(false, nil)
            return
        }
        if user.password.isEmpty {
            errorMessage = Constants.TextConstants.emptyPassword
            completion(false, nil)
            return
        }
        
        if user.password.count < 6 {
             errorMessage = "Şifre en az 6 karakter uzunluğunda olmalıdır."
             completion(false, nil)
             return
         }
        
        //auth ekleme
        Auth.auth().createUser(withEmail: user.email, password: user.password) { [weak self] authResult, error in
            if let error = error as NSError? {
                DispatchQueue.main.async {
                    
                    switch error.code {
                           case AuthErrorCode.weakPassword.rawValue:
                               self?.errorMessage = "Şifre en az 6 karakter uzunluğunda olmalıdır."
                           case AuthErrorCode.emailAlreadyInUse.rawValue:
                               self?.errorMessage = "Bu e-posta adresi zaten kullanımda."
                           case AuthErrorCode.invalidEmail.rawValue:
                               self?.errorMessage = "Geçersiz e-posta formatı."
                           default:
                               self?.errorMessage = "Kayıt sırasında hata oluştu: \(error.localizedDescription)"
                           }
                    completion(false, nil)
                }
                return
            }
            
            guard let userId = authResult?.user.uid else {
                DispatchQueue.main.async {
                    self?.errorMessage = "Kullanıcı ID alınamadı"
                    completion(false, nil)
                }
                return
            }
            
            // firestore kaydetme
            let db = Firestore.firestore()
            let userData: [String: Any] = [
                "id": userId,
                "username": self?.user.username ?? "",
                "email": self?.user.email ?? "",
                "age": self?.user.age ?? "",
                "password": self?.user.password ?? ""
            ]
            
            db.collection("users").document(userId).setData(userData) { [weak self] error in
                if let error = error {
                    DispatchQueue.main.async {
                        self?.errorMessage = "Firestore verisi kaydedilirken hata oluştu: \(error.localizedDescription)"
                        completion(false, nil)
                    }
                    return
                }
                
                DispatchQueue.main.async {
                    self?.errorMessage = nil
                    self?.user.id = userId
                    completion(true, self?.user)
                }
            }
        }
    }

    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailTest.evaluate(with: email)
    }
    
    private func isValidAge(_ age: String) -> Bool {
        guard let userAge = Int(user.age) else {
            return false
        }
        return userAge >= 18
    }
}

