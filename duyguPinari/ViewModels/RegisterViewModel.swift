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
        static let invalidAgeFormat = "Yaş formatı geçersiz. Lütfen '15.11.1997' formatını kullanın."
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
        
        // First, create the user in Firebase Auth
        Auth.auth().createUser(withEmail: user.email, password: user.password) { [weak self] authResult, error in
            if let error = error {
                DispatchQueue.main.async {
                    self?.errorMessage = error.localizedDescription
                    completion(false, nil)
                }
                return
            }
            
            // Ensure the user is authenticated and retrieve the user ID
            guard let userId = authResult?.user.uid else {
                DispatchQueue.main.async {
                    self?.errorMessage = "Kullanıcı ID alınamadı"
                    completion(false, nil)
                }
                return
            }
            
            // Now, save the user data to Firestore
            let db = Firestore.firestore()
            let userData: [String: Any] = [
                "id": userId,
                "username": self?.user.username ?? "",
                "email": self?.user.email ?? "",
                "age": self?.user.age ?? "",
                "password": self?.user.password ?? "" // Storing password in Firestore is generally not recommended, use it only for example purposes
            ]
            
            db.collection("users").document(userId).setData(userData) { [weak self] error in
                if let error = error {
                    DispatchQueue.main.async {
                        self?.errorMessage = "Firestore verisi kaydedilirken hata oluştu: \(error.localizedDescription)"
                        completion(false, nil)
                    }
                    return
                }
                
                // Once the user data is saved in Firestore, proceed to update the ViewModel
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
        let ageRegex = "^\\d{2}\\.\\d{2}\\.\\d{4}$"
        let ageTest = NSPredicate(format: "SELF MATCHES %@", ageRegex)
        if !ageTest.evaluate(with: age) {
            return false
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        dateFormatter.locale = Locale(identifier: "tr_TR")
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        if let _ = dateFormatter.date(from: age) {
            return true
        } else {
            return false
        }
    }
}

