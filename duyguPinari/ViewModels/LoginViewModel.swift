//
//  LoginViewModel.swift
//  duyguPinari
//
//  Created by İlknur Tulgar on 17.11.2024.
//

import SwiftUI

class LoginViewModel: ObservableObject{
    @Published var email: String = ""
    @Published  var password: String = ""
    @Published var errorMessage: String? = nil
    
    struct LoginConstants{
        static let sign = "GİRİŞ"
        static let signIn = "YAP"
    }
    
    //dummy kullanıcı verisi
    private var dummyUsers: [User] = [
        User(username: "Alara Orea", email: "ala@example.com", age: "15.11.2002", password: "123")]
    func loginUser() -> Bool {
        if !isValidEmail(email) {
            errorMessage = Constants.TextConstants.unvalidEmail
            return false
        }
        
        if password.isEmpty {
            errorMessage = Constants.TextConstants.emptyPassword
            return false
        }
        
        if let _ = dummyUsers.first(where: { $0.email == email && $0.password == password }) {
            errorMessage = nil
            return true
        } else {
            errorMessage = Constants.TextConstants.unvalidInfo
            return false
        }
    }
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@",emailRegex)
        return emailTest.evaluate(with: email)
    }
}
