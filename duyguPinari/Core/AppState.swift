//
//  AppState.swift
//  duyguPinari
//
//  Created by İlknur Tulgar on 27.11.2024.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore


class AppState: ObservableObject {
    @Published var isLoggedIn = false
    @Published var selectedTab: String = "Home"
    @Published var currentUser: User?
    @Published var isLoading: Bool = false // Veri yükleniyor durumu
    
    init() {
        if let _ = Auth.auth().currentUser {
            fetchUserProfile()

        }
    }
    
    func fetchUserProfile() {
        guard let userID = Auth.auth().currentUser?.uid else { 
            print("No Firebase Auth user found.")
            self.currentUser = nil
            return }
        let db = Firestore.firestore()
        
        self.isLoading = true // Yükleme başladığında loading durumu aktif
        db.collection("users").document(userID).getDocument { (document, error) in
            
            if let document = document, document.exists {
                let data = document.data()
                let id = data?["id"] as? String ?? ""
                let username = data?["username"] as? String ?? ""
                let email = data?["email"] as? String ?? ""
                let age = data?["age"] as? String ?? ""
                let password = data?["password"] as? String ?? ""
                let about = data?["about"] as? String ?? ""
                self.currentUser = User(id: id, username: username, email: email, age: age, password: password,about: about)
            }else{
                print("no loggeed")
            }
            self.isLoading = false // Veri yüklendikten sonra loading durumu false
        }
    }
    
}
