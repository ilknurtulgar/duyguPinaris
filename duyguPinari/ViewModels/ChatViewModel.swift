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
        isLoading = true
        db.collection("users")
            .document(currentUserId)
            .collection("chats")
            .document(chatUserId)
            .collection("messages")
            .order(by: "timestamp")
            .getDocuments { snapshot, error in
                if let error = error {
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
    
    // Yeni mesaj gönderme ve son mesajı güncelleme
    func sendMessage(to chatUserId: String, messageContent: String, currentUserId: String) {
        let messageData: [String: Any] = [
            "content": messageContent,
            "senderID": currentUserId,
            "timestamp": FieldValue.serverTimestamp()
        ]
        
        // Giriş yapan kullanıcının koleksiyonuna mesaj ekleme
        db.collection("users").document(currentUserId)
            .collection("chats").document(chatUserId)
            .collection("messages").addDocument(data: messageData) { error in
                if let error = error {
                    print("Mesaj gönderilemedi1: \(error.localizedDescription)")
                } else {
                    print("Mesaj başarıyla gönderildi.")
                    //llastmessage da eklemee
                    self.updateLastMessage(for: chatUserId,newMessage:messageContent,currentUserId: currentUserId)
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
                    self.updateLastMessage(for: currentUserId,newMessage:messageContent,currentUserId: currentUserId)
                    self.incrementUnreadMessages(for: chatUserId,senderId: currentUserId)
                }
            }
    }
    
    func incrementUnreadMessages(for chatUserId: String, senderId: String){
        let chatDocRef = db.collection("users").document(chatUserId)
            .collection("chats").document(senderId)
        chatDocRef.updateData(["unreadMessage": FieldValue.increment(Int64(1))]){
            error in
            if let error = error {
                print("okunmamış mesajlar güncellenemedi \(error.localizedDescription)")
            }else{
                print("okunmamış mesaj sayısı güncellendi")
            }
        }
    }
    
    func resetUnreadMessages(for currentUserId: String, chatUserId: String) {
        let chatDocRef = db.collection("users").document(currentUserId)
            .collection("chats").document(chatUserId)
        
        chatDocRef.updateData(["unreadMessage": 0]){error in
            if let error = error{
                print("unread mesaj sıfırlanamadı \(error.localizedDescription)")
            }else{
                print("unread mesaj başarıyla sıfırlandı.")
            }
        }
    }
    
    func updateLastMessage(for chatUserId: String,newMessage: String, currentUserId: String){
        //giriş yapan kullanıcının chatini güncelleme
        db.collection("users").document(currentUserId).collection("chats").document(chatUserId).updateData(["lastMessage": newMessage,"timestamp": FieldValue.serverTimestamp()]){error in
            if let error = error {
                print("lastMessage güncellenirken hata oluştu[currentUserId]:\(error.localizedDescription)")
            }else{
                print("lastMessage başarıyla güncellendi[currentUserId].")
            }
        }
        db.collection("users").document(chatUserId).collection("chats").document(currentUserId).updateData(["lastMessage": newMessage,"timestamp": FieldValue.serverTimestamp()]){error in
            if let error = error{
                print("lastMessage güncellenirken hata oluştu[chatUserId]: \(error.localizedDescription)")
            }else{
                print("lastMessage başarıyla güncellendi[chatUserId].")
            }
        }
    }
}

