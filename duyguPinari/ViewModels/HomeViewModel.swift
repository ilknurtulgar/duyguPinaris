//
//  HomeViewModel.swift
//  duyguPinari
//
//  Created by İlknur Tulgar on 26.11.2024.
//

import SwiftUI
import FirebaseFirestore

class HomeViewModel: ObservableObject {
//    @Published var currentUser: User?
  //  @Published var chatUsers: [ChatUser] = []
}

  /*  func fetchChatUsers(for user: User) {
        let db = Firestore.firestore()

        db.collection("chatUsers")
            .document(user.id)
            .collection("chatUsers")
            .getDocuments { (snapshot, error) in
                if let error = error {
                    print("Error fetching chat users: \(error.localizedDescription)")
                    return
                }

                guard let documents = snapshot?.documents else {
                    print("No documents found.")
                    return
                }*/

               /* let users: [ChatUser] = documents.compactMap { doc in
                    guard let username = doc["username"] as? String,
                          let message = doc["message"] as? String,
                          let unreadMessages = doc["unreadMessages"] as? Int,
                          let profileImageURL = doc["profileImage"] as? String else {
                        return nil
                    }

                    let defaultImage = Image(systemName: "person.circle")
                    let image = URL(string: profileImageURL).flatMap { self.loadImage(from: $0) } ?? defaultImage

                    return ChatUser(
                        username: username,
                        message: message,
                        unreadMessages: unreadMessages,
                        profileImage: image
                    )
                }*/

               /* DispatchQueue.main.async {
                    self.chatUsers = users
                }*/
// 
   /*}

    private func loadImage(from url: URL) -> Image? {
        do {
            let data = try Data(contentsOf: url)
            if let uiImage = UIImage(data: data) {
                return Image(uiImage: uiImage)
            }
        } catch {
            print("Error loading image: \(error.localizedDescription)")
        }
        return nil
    }
   */

