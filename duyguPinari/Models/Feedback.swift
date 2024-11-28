//
//  Feedback.swift
//  duyguPinari
//
//  Created by İlknur Tulgar on 17.11.2024.
//

import SwiftUI

struct Feedback: Identifiable{
    var id:String
    var receiverID: String
    var senderID: String
    var profileImage: String?
    var username: String
    var role: String
    var rating: Int
    var feedbackText: String
}
