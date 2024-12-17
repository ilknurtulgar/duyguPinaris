//
//   AuthenticationManager.swift
//  duyguPinari
//
//  Created by İlknur Tulgar on 17.12.2024.
//

import FirebaseAuth

class AuthenticationManager {
    static let shared = AuthenticationManager()

    // Kullanıcıyı yeniden kimlik doğrulama işlemi
    func reauthenticateUser(currentPassword: String, completion: @escaping (Bool, String?) -> Void) {
        guard let currentUser = Auth.auth().currentUser else {
            completion(false, "Mevcut kullanıcı bulunamadı!")
            return
        }

        let credential = EmailAuthProvider.credential(withEmail: currentUser.email!, password: currentPassword)

        currentUser.reauthenticate(with: credential) { result, error in
            if let error = error {
                completion(false, "Yeniden kimlik doğrulama başarısız: \(error.localizedDescription)")
                return
            }
            completion(true, nil)
        }
    }

    // E-posta güncelleme ve doğrulama e-postası gönderme
    func updateEmail(newEmail: String, currentPassword: String, completion: @escaping (Bool, String?) -> Void) {
        guard let currentUser = Auth.auth().currentUser else {
            completion(false, "Mevcut kullanıcı bulunamadı!")
            return
        }

        // Kullanıcıyı yeniden kimlik doğrulama yapması için istek gönder
        reauthenticateUser(currentPassword: currentPassword) { success, errorMessage in
            if !success {
                completion(false, errorMessage)
                return
            }

            // E-posta adresi güncelleniyor
            currentUser.updateEmail(to: newEmail) { error in
                if let error = error {
                    completion(false, "E-posta güncellenirken hata oluştu: \(error.localizedDescription)")
                    return
                }

                // Yeni e-posta adresine doğrulama e-postası gönderiliyor
                currentUser.sendEmailVerification { error in
                    if let error = error {
                        completion(false, "Doğrulama e-postası gönderilirken hata oluştu: \(error.localizedDescription)")
                    } else {
                        completion(true, "Lütfen e-posta adresinizi doğrulayın.")
                    }
                }
            }
        }
    }
}
