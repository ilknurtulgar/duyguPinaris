//
//  LoginViewModel.swift
//  duyguPinari
//
//  Created by İlknur Tulgar on 17.11.2024.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

class LoginViewModel: ObservableObject{
    @Published var errorMessage: String?
    @Published var user = User(id: "",username: "", email: "", age: "", password: "")
   
    struct LoginConstants{
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
        
        guard !user.password.isEmpty  else{
            errorMessage = Constants.TextConstants.emptyPassword
            completion(false)
            return
        }
        
        Auth.auth().signIn(withEmail: user.email, password: user.password){[weak self] authResult,error in
            if let error = error {
                self?.errorMessage = error.localizedDescription
                completion(false)
                return
            }
            if let userId = authResult?.user.uid {
                Firestore.firestore().collection("users").document(userId).getDocument { document , error in
                    if let document = document,document.exists{
                        let data = document.data()
                        self?.user.id = userId
                        self?.user.username = data?["username"] as? String ?? ""
                        self?.user.email = data?["email"] as? String ?? ""
                        self?.user.age = data?["age"] as? String ?? ""
                        self?.user.password = self?.user.password ?? ""
                        
                        DispatchQueue.main.async{
                            self?.errorMessage = nil
                           
                            completion(true)
                        }
                    }else{
                        self?.errorMessage = "Kullanıcı verisi alınmadı."
                        completion(false)
                    }
                }
            }
        }
    }
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@",emailRegex)
        return emailTest.evaluate(with: email)
    }
}
