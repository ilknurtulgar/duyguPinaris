//
//  HomeViewModel.swift
//  duyguPinari
//
//  Created by İlknur Tulgar on 26.11.2024.
//

import SwiftUI
import FirebaseFirestore

class HomeViewModel: ObservableObject{
    @Published var chatUsers: [ChatUser] = []
    private var appState: AppState
    private var db = Firestore.firestore()
    
    init(appState: AppState) {
        self.appState = appState
    fetchChatUsers()
    }
    
    func fetchChatUsers(){
        guard let userID = appState.currentUser?.id else{
            print("no user logged in")
            return
        }
        
        db.collection("users").document(userID).collection("chats")
            .getDocuments{[weak self] snapshot, error in
                if let error = error {
                    print("error fetching chats: \(error.localizedDescription)")
                    return
                }
                
                self?.chatUsers = snapshot?.documents.compactMap{ document in
                    let data = document.data()
                    return ChatUser(id: document.documentID, username: data["username"] as? String ?? "nullim", message: data["lastMessage"] as? String ?? "", unreadMessage: data["unreadMessages"] as? Int ?? 0,
                    profileImage: data["profileImage"] as? String ?? ""
                    )
                } ?? []
                
            }
    }
}

