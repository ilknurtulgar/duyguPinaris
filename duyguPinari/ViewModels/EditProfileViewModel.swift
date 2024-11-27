//
//  EditProfileViewModel.swift
//  duyguPinari
//
//  Created by İlknur Tulgar on 27.11.2024.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

class EditProfileViewModel: ObservableObject {
    @Published var user: User
    @Published var isLoading: Bool = false
    
    private var appState: AppState
    
    init(appState: AppState){
        self.appState = appState
        if let currentUser = appState.currentUser{
            self.user = currentUser
        }else{
            self.user = User(id: "", username: "", email: "", age: "", password: "", about: nil)
        }
    }
    
    func updateUserProfile() {
        guard let userID = Auth.auth().currentUser?.uid else {return}
        let db = Firestore.firestore()
        self.isLoading = true
        
        db.collection("users").document(userID).updateData([
            "username": user.username,
            "email": user.email,
            "age": user.age,
            "password": user.password,
            "about": user.about ?? ""
        ]){error in
            self.isLoading = false
            if let error = error{
                print("error updating profile: \(error.localizedDescription)")
            }else{
                self.appState.currentUser = self.user
               /* self.appState.currentUser?.username = self.user.username
                self.appState.currentUser?.email = self.user.email
                self.appState.currentUser?.age = self.user.age
                self.appState.currentUser?.password = self.user.password
                self.appState.currentUser?.about = self.user.about*/
                print("profile updated successfully")
            }
            
        }
    }
}
