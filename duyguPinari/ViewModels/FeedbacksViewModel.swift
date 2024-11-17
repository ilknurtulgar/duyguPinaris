//
//  FeedbacksViewModel.swift
//  duyguPinari
//
//  Created by İlknur Tulgar on 17.11.2024.
//

import SwiftUI

class FeedbacksViewModel: ObservableObject{
    @Published var feedbacks: [Feedback] = [
        Feedback(
                  profileImage: Image(systemName: "person.circle"),
                  name: "Alexa Richardson",
                  role: "Listener",
                  rating: 4,
                  feedbackText: "Great conversation! Really enjoyed it!"
              ),
              Feedback(
                  profileImage: Image(systemName: "person.circle"),
                  name: "John Doe",
                  role: "Narrator",
                  rating: 5,
                  feedbackText: "Fantastic insights. Thank you for your support!"
              ),
              Feedback(
                  profileImage: Image(systemName: "person.circle"),
                  name: "Jane Smith",
                  role: "Listener",
                  rating: 3,
                  feedbackText: "Good conversation. Thanks for listening!"
              )
    ]
}
