//
//  LoginViewModel.swift
//  duyguPinari
//
//  Created by İlknur Tulgar on 17.11.2024.
//

import SwiftUI
import FirebaseAuth

class LoginViewModel: ObservableObject{
    @Published var email: String = ""
    @Published  var password: String = ""
    @Published var errorMessage: String?
    
    struct LoginConstants{
        static let sign = "GİRİŞ"
        static let signIn = "YAP"
    }
    
    
    func loginUser(completion: @escaping (Bool) -> Void) {
        
        guard !email.isEmpty else {
            errorMessage = "Lütfen e-posta adresinizi girin."
            completion(false)
            return
        }
        
        guard isValidEmail(email) else  {
            errorMessage = Constants.TextConstants.unvalidEmail
            completion(false)
            return
        }
        
        guard !password.isEmpty  else{
            errorMessage = Constants.TextConstants.emptyPassword
            completion(false)
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password){[weak self] authResult,error in
            if let error = error {
                self?.errorMessage = error.localizedDescription
                completion(false)
            }
            return
        }
        // girişin başarılı olması durumu
        DispatchQueue.main.async{
            self.errorMessage = nil
            completion(true)
        }
    }
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@",emailRegex)
        return emailTest.evaluate(with: email)
    }
}
