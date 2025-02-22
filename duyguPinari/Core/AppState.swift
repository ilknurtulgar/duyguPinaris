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
    @Published var isLoading: Bool = false
    @Published var homeViewModel: HomeViewModel?
    @Published var chatUsers: [ChatUser] = []
    init() {
        print("appstate initialized")
        //kullanıcı kontrolü
        if Auth.auth().currentUser != nil {
            fetchUserProfile()
        } else {
            // Kullanıcı giriş yapmamışsa
            print("No user is logged in.")
        }
        
    }
    
    func fetchUserProfile() {
        guard let userID = Auth.auth().currentUser?.uid else {
            print("No Firebase Auth user found.")
            self.currentUser = nil
            return }
        let db = Firestore.firestore()
        
        self.isLoading = true
        db.collection("users").document(userID).getDocument { (document, error) in
            if let error = error {
                print("error fetching user profile: \(error.localizedDescription)")
            }
            else  if let document = document, document.exists {
                let data = document.data()
                self.currentUser = User(id: data?["id"] as? String ?? "", username: data?["username"] as? String ?? "", email: data?["email"] as? String ?? "", age: data?["age"] as? String ?? "", password:  data?["password"] as? String ?? "",about:data?["about"] as? String ?? "" ,
                                        talkState: data?["talkState"] as? Bool ?? false,
                                        profileImageURL: data?["profileImageURL"] as? String ?? "")
            }else{
                print("no document found for userID: \(userID)")
            }
            
            self.isLoading = false
            
            
        }
    }
    
}
