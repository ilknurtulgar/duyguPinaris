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
    
    //dummy kullanıcı verisi
    private var dummyUsers: [User] = [
        User(username: "Alara Orea", email: "alara@example.com", age: "15.11.2002", password: "123")]
    func loginUser() -> Bool {
        // E-posta doğrulama
        if !isValidEmail(email) {
            errorMessage = "Geçersiz e-posta adresi"
            print("Hata: Geçersiz e-posta adresi") // Debug log
            return false
        }
        
        // Şifre boş kontrolü
        if password.isEmpty {
            errorMessage = "Şifre boş olamaz"
            print("Hata: Şifre boş olamaz") // Debug log
            return false
        }
        
        // Kullanıcı kontrolü
        if let _ = dummyUsers.first(where: { $0.email == email && $0.password == password }) {
            // Başarılı giriş
            errorMessage = nil
            print("Başarılı giriş!") // Debug log
            return true
        } else {
            // E-posta veya şifre hatalı
            errorMessage = "E-posta veya şifre hatalı"
            print("Hata: E-posta veya şifre hatalı") // Debug log
            return false
        }
    }
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@",emailRegex)
        return emailTest.evaluate(with: email)
    }
}
