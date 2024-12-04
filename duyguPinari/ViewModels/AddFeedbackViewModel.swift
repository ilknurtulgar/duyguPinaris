//
//  AddFeedbackViewModel.swift
//  duyguPinari
//
//  Created by İlknur Tulgar on 4.12.2024.
//

import SwiftUI
import FirebaseFirestore

class AddFeedbackViewModel: ObservableObject {
    @Published var errorMessage: String? = nil
    @Published var isDone: Bool = false
    private let db = Firestore.firestore()
    
    func addFeedbackAndDeleteChat(feedback: Feedback, currentUserId: String, chatUserId: String, completion: @escaping (Bool) -> Void) {
        guard feedback.rating > 0 else {
            errorMessage = "Lütfen bir skor seçin."
            completion(false)
            return
        }
    
        db.collection("feedbacks").document(feedback.id).setData([
            "id": feedback.id,
            "receiverID": feedback.receiverID,
            "senderID": feedback.senderID,
            "profileImage": feedback.profileImage ?? "",
            "username": feedback.username,
            "role": feedback.role,
            "rating": feedback.rating,
            "feedbackText": feedback.feedbackText
        ]) { [weak self] error in
            if error != nil {
                self?.errorMessage = "Geri bildirim eklenirken hata oluştu"
                completion(false)
                return
            }
            
            self?.deleteChatData(currentUserId: currentUserId, chatUserId: chatUserId) { success in
                if success {
                    self?.isDone = true
                    completion(true)
                } else {
                    self?.errorMessage = "Sohbet silinirken hata oluştu."
                    completion(false)
                }
            }
        }
    }
    
    func deleteChatData(currentUserId: String, chatUserId: String, completion: @escaping (Bool) -> Void) {
        let group = DispatchGroup()
        var isSuccessful = true
        
        group.enter()
        deleteMessagesAndChat(for: currentUserId, with: chatUserId) { success in
            if !success {
                isSuccessful = false
            }
            group.leave()
        }
        
        group.enter()
        deleteMessagesAndChat(for: chatUserId, with: currentUserId) { success in
            if !success {
                isSuccessful = false
            }
            group.leave()
        }
        
        group.notify(queue: .main) {
            completion(isSuccessful)
        }
    }
    
    private func deleteMessagesAndChat(for userId: String, with chatUserId: String, completion: @escaping (Bool) -> Void) {
        db.collection("users")
            .document(userId)
            .collection("chats")
            .document(chatUserId)
            .collection("messages")
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Mesajlar alınırken hata oluştu: \(error.localizedDescription)")
                    completion(false)
                    return
                }
                
                let documents = snapshot?.documents ?? []
                let group = DispatchGroup()
                var isSuccessful = true
                
                for document in documents {
                    group.enter()
                    document.reference.delete { error in
                        if let error = error {
                            print("Mesaj silinirken hata oluştu: \(error.localizedDescription)")
                            isSuccessful = false
                        }
                        group.leave()
                    }
                }
                
                group.notify(queue: .main) {
                    self.db.collection("users")
                        .document(userId)
                        .collection("chats")
                        .document(chatUserId)
                        .delete { error in
                            if let error = error {
                                print("Sohbet silinirken hata oluştu: \(error.localizedDescription)")
                                completion(false)
                            } else {
                                completion(isSuccessful)
                            }
                        }
                }
            }
    }
}
