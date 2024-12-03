//
//  Message.swift
//  duyguPinari
//
//  Created by İlknur Tulgar on 3.12.2024.
//

import SwiftUI

struct ChatMessage: Identifiable, Equatable {
    var id: String
    var content: String
    var senderID: String
    var timestamp: Date

    static func == (lhs: ChatMessage, rhs: ChatMessage) -> Bool {
        return lhs.id == rhs.id &&
               lhs.content == rhs.content &&
               lhs.senderID == rhs.senderID &&
               lhs.timestamp == rhs.timestamp
    }
}
