//
//  ChatViewModel.swift
//  duyguPinari
//
//  Created by İlknur Tulgar on 3.12.2024.
//

import SwiftUI
import FirebaseFirestore

class ChatViewModel: ObservableObject {
    @Published var messages: [ChatMessage] = []
    @Published var isLoading: Bool = false
    //@EnvironmentObject var appState: AppState
    private var db = Firestore.firestore()
    
    func fetchAbout(for chatUserId: String, completion: @escaping (String?) -> Void) {
        db.collection("users").document(chatUserId).getDocument { document, error in
            if let error = error {
                print("Hakkında bilgisi alınamadı: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            if let document = document, document.exists, let about = document.data()?["about"] as? String {
                completion(about)
            } else {
                completion(nil)
            }
        }
    }

    
    func fetchMessages(for chatUserId: String, currentUserId: String) {
        print("current: \(currentUserId)")
        print("chatuserID: \(chatUserId)")
        isLoading = true
        db.collection("users")
            .document(currentUserId)
            .collection("chats")
            .document(chatUserId)
            .collection("messages")
            .order(by: "timestamp")
            .getDocuments { snapshot, error in
                if let error = error {
                    print("\(chatUserId)")
                    print("Mesajlar çekilemedi: \(error.localizedDescription)")
                    self.isLoading = false
                    return
                }
                
                // Mesajları `ChatMessage` modeline dönüştürme
                self.messages = snapshot?.documents.compactMap { document in
                    let data = document.data()
                    guard let content = data["content"] as? String,
                          let senderID = data["senderID"] as? String,
                          let timestamp = data["timestamp"] as? Timestamp else {
                        return nil
                    }
                    
                    // `document.documentID` doğrudan kullanılabilir
                    return ChatMessage(id: document.documentID, content: content, senderID: senderID, timestamp: timestamp.dateValue())
                } ?? []
                
                self.isLoading = false
            }
    }
    
    // Yeni mesaj gönderme
    func sendMessage(to chatUserId: String, messageContent: String, currentUserId: String) {
        let messageData: [String: Any] = [
            "content": messageContent,
            "senderID": currentUserId,
            "timestamp": FieldValue.serverTimestamp()
        ]
        
        // Giriş yapan kullanıcının koleksiyonuna mesaj ekleme
        print("userscurr:\(currentUserId)")
        db.collection("users").document(currentUserId)
            .collection("chats").document(chatUserId)
            .collection("messages").addDocument(data: messageData) { error in
                if let error = error {
                    print("Mesaj gönderilemedi1: \(error.localizedDescription)")
                } else {
                    print("Mesaj başarıyla gönderildi.")
                }
            }
        
        // Konuşulan kullanıcının koleksiyonuna mesaj ekleme
        db.collection("users").document(chatUserId)
            .collection("chats").document(currentUserId)
            .collection("messages").addDocument(data: messageData) { error in
                if let error = error {
                    print("Mesaj gönderilemedi: \(error.localizedDescription)")
                } else {
                    print("Mesaj başarıyla gönderildi.")
                }
            }
    }
}

