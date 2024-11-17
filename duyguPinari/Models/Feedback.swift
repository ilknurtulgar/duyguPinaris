//
//  Feedback.swift
//  duyguPinari
//
//  Created by İlknur Tulgar on 17.11.2024.
//

import SwiftUI

struct Feedback: Identifiable{
    let id = UUID()
    var profileImage: Image
    var name: String
    var role: String
    var rating: Int
    var feedbackText: String
}
