//
//  RegisterViewModel.swift
//  duyguPinari
//
//  Created by İlknur Tulgar on 17.11.2024.
//

import SwiftUI
import FirebaseAuth

class RegisterViewModel: ObservableObject{
    @Published var username: String = ""
    @Published var email: String = ""
    @Published var age: String = ""
    @Published var password: String = ""
    @Published  var errorMessage: String? = nil
    
    struct RegisterConstants {
        static let sign = "KAYIT"
        static let signUp = "OL"
        static let usernameEmpty = "Kullanıcı adı boş"
        static let invalidAgeFormat = "Yaş formatı geçersiz.Lütfen '15.11.1997' formatını kullanın."
    }

    func registerUser(completion: @escaping (Bool) -> Void) {
    
        if username.isEmpty {
            errorMessage = RegisterConstants.usernameEmpty
            completion(false)
            return
        }
        if !isValidEmail(email){
            errorMessage = Constants.TextConstants.unvalidEmail
            completion(false)
            return
        }
        if !isValidAge(age){
            errorMessage = RegisterConstants.invalidAgeFormat
            completion(false)
            return
        }
        if password.isEmpty {
            errorMessage = Constants.TextConstants.emptyPassword
            completion(false)
            return
        }
        Auth.auth().createUser(withEmail: email, password: password){ [weak self] authResult, error in
            if let error = error{
                DispatchQueue.main.async {
                    self?.errorMessage = error.localizedDescription
                    completion(false)
                }
                return
            }
            // kullanıcı kaydedildi ve veri ekleme
            DispatchQueue.main.async {
                self?.errorMessage = nil
                completion(true)
            }
        }
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@",emailRegex)
        return emailTest.evaluate(with: email)
    }
    private func isValidAge(_ age: String) -> Bool{
        let ageRegex = "^\\d{2}\\.\\d{2}\\.\\d{4}$"
        let ageTest = NSPredicate(format: "SELF MATCHES %@", ageRegex)
        if !ageTest.evaluate(with: age){
            return false
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat="dd.MM.yyyy"
        dateFormatter.locale = Locale(identifier: "tr_TR")
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        if let _ = dateFormatter.date(from:age){
            return true
        }else{
            return false
        }
    }
    
}
