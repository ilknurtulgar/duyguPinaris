//
//  HomeViewModel.swift
//  duyguPinari
//
//  Created by İlknur Tulgar on 26.11.2024.
//

import SwiftUI
import FirebaseFirestore

class HomeViewModel: ObservableObject {
    @Published var chatUsers: [ChatUser] = []
    private var appState: AppState
    let db = Firestore.firestore()
    
    init(appState: AppState) {
        self.appState = appState
        self.chatUsers = appState.chatUsers // Başlangıçta AppState'teki kullanıcıları al
    }
    
    func fetchChatUsers(for userId: String, forceReload: Bool = false, completion: @escaping () -> Void) {
        if !forceReload, !appState.chatUsers.isEmpty {
            print("AppState'den kullanıcılar gösteriliyor, tekrar yüklenmiyor.")
            self.chatUsers = appState.chatUsers
            completion()
            return
        }
        
        db.collection("users").document(userId).collection("chats")
            .order(by: "timestamp", descending: true)
            .getDocuments { [weak self] snapshot, error in
                if let error = error {
                    print("Sohbet verisi çekilemedi: \(error.localizedDescription)")
                    completion()
                    return
                }
                
                guard let self = self else { return }
                let chatDocuments = snapshot?.documents ?? []
                var fetchedUsers: [ChatUser] = []
                let group = DispatchGroup()
                
                for document in chatDocuments {
                    let data = document.data()
                    guard let users = data["users"] as? [String],
                          let lastMessage = data["lastMessage"] as? String,
                          let unreadMessage = data["unreadMessage"] as? Int,
                          let profileImage = data["profileImage"] as? String,
                          let topic = data["topic"] as? String,
                          let role = data["role"] as? String 
                    else { continue }
                    
                    let chatUserId = users.first { $0 != userId } ?? ""
                    
                    group.enter()
                    self.db.collection("users").document(chatUserId).getDocument { userSnapshot, userError in
                        if let userError = userError {
                            print("Kullanıcı bilgisi getirilemedi: \(userError.localizedDescription)")
                        } else if let userData = userSnapshot?.data(),
                                  let username = userData["username"] as? String {
                            let chatUser = ChatUser(
                                id: chatUserId,
                                username: username,
                                message: lastMessage,
                                unreadMessage: unreadMessage,
                                profileImage: profileImage,
                                topic: topic,
                                role: role
                            )
                            fetchedUsers.append(chatUser)
                        }
                        group.leave()
                    }
                }
                
                group.notify(queue: .main) {
                    print("Kullanıcılar: \(fetchedUsers)")
                    self.chatUsers = fetchedUsers
                    self.appState.chatUsers = fetchedUsers
                    completion()
                }
            }
    }
    
}


