//
//  RegisterViewModel.swift
//  duyguPinari
//
//  Created by İlknur Tulgar on 17.11.2024.
//

import SwiftUI

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
    private var registeredUsers:[User]=[]
    func registerUser() -> Bool {
        
        if !isValidEmail(email){
            errorMessage = Constants.TextConstants.unvalidEmail
            return false
        }
       
        if username.isEmpty {
            errorMessage = RegisterConstants.usernameEmpty
            return false
        }
        if !isValidAge(age){
            errorMessage = RegisterConstants.invalidAgeFormat
            return false
        }
        if password.isEmpty {
            errorMessage = Constants.TextConstants.emptyPassword
            return false
        }
        let newUser=User(username: username, email: email, age: age, password: password)
        registeredUsers.append(newUser)
        return true
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
