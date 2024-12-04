//
//  FeedbacksViewModel.swift
//  duyguPinari
//
//  Created by İlknur Tulgar on 17.11.2024.
//

import SwiftUI
import FirebaseFirestore

class FeedbacksViewModel: ObservableObject {
    @Published var feedbacks: [Feedback] = []
    private var appState: AppState
    
    init(appState: AppState) {
        self.appState = appState
        fetchFeedbacks()
    }
    
    func fetchFeedbacks() {
        guard let userID = appState.currentUser?.id else {
            print("No user logged in")
            return
        }
      //  print("Fetching feedbacks for user ID: \(userID)")
        let db = Firestore.firestore()
        
        // userID'yi kullanarak doğru koleksiyona sorgu gönderiyoruz
        
        db.collection("feedbacks")
            .whereField("senderID", isEqualTo: userID)
            .getDocuments{ [weak self] snapshot, error in
                if let error = error {
                    print("error getting feedbacks: \(error.localizedDescription)")
                    return
                }
                
                self?.feedbacks = snapshot?.documents.compactMap { document in
                    let data = document.data()
                    return Feedback(
                        id: document.documentID,
                        receiverID: data["receiverID"] as? String ?? "",
                        senderID:  data["senderID"] as? String ?? "",
                        profileImage: data["profileImageURL"] as? String,
                        username: data["username"] as? String ?? "nullim",
                        role: data["role"] as? String ?? "nullim",
                        rating: data["rating"] as? Int ?? 0,
                        feedbackText: data["feedbackText"] as? String ?? "nullim"
                    )
                } ?? []
            }
            }
    }


