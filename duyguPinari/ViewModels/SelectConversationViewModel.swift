//
//  SelectConversationViewModel.swift
//  duyguPinari
//
//  Created by İlknur Tulgar on 30.11.2024.
//

import SwiftUI
import FirebaseFirestore

class SelectConversationViewModel: ObservableObject {
    @Published var feedbacks: [Feedback] = []
    let db = Firestore.firestore()
    var homeViewModel: HomeViewModel?
    
    func startChat(with user: User,currentUser: User){
        let currentUserChatData: [String: Any] = [
            "users": [currentUser.id,user.id],
            "lastMessage": "Sohbete başlamak için tıklayın",
            "unreadMessage": 0,
            "profileImage": "",
            "timestamp": FieldValue.serverTimestamp()
        ]
        let matchedUserChatData: [String: Any] = [
            "users": [user.id,currentUser.id],
            "lastMessage": "Sohbete başlamak için tıklayın",
            "unreadMessage": 0,
            "profileImage": "",
            "timestamp": FieldValue.serverTimestamp()
        ]
        
        db.collection("users").document(currentUser.id).collection("chats").document(user.id).setData(currentUserChatData){error in
            if let error = error{
                print("currentUser: sohbet oluşturulamadı: \(error.localizedDescription)")
            }else{
                print("currentUser: sohbet başarıyla başlatıldı.")
            }
        }
        db.collection("users").document(user.id).collection("chats").document(currentUser.id).setData(matchedUserChatData){ error in
            if let error = error{
                print("matchedUser: sohbet oluşturulamadı: \(error.localizedDescription)")
            }else{
                print("matchedUser: sohbet başarıyla başlatıldı.")
            }
        }
        self.homeViewModel?.fetchChatUsers(for: currentUser.id){
            
        }
    }
    
    func fetchFeedbacks(for userId: String){
        db.collection("feedbacks")
            .whereField("receiverID", isEqualTo: userId)
            .getDocuments{
                snapshot , error in
                if let error = error {
                    print("feedback çekme hatalı: \(error.localizedDescription)")
                    return
                }
                //dokümanı çevirme
                let feedbacks = snapshot?.documents.compactMap{document -> Feedback? in
                    let data = document.data()
                    guard let id = document.documentID as String?,
                          let receiverID = data["receiverID"] as? String,
                          let senderID = data["senderID"] as? String,
                          let profileImageURL = data["profileImageURL"] as? String?,
                          let username = data["username"] as? String,
                          let role = data["role"] as? String,
                          let rating = data["rating"] as? Int,
                          let feedbackText = data["feedbackText"] as? String else{
                        return nil
                    }
                    return Feedback(id: id, receiverID: receiverID, senderID: senderID,profileImage: profileImageURL, username: username, role: role, rating: rating, feedbackText: feedbackText)
                } ?? []
                // random 2 feedback
                if feedbacks.count > 1{
                    self.feedbacks = Array(feedbacks.shuffled().prefix(2))
                }else{
                    self.feedbacks = feedbacks
                }
            }
    }
}
