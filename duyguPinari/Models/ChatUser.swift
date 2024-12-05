//
//  ChatUser.swift
//  duyguPinari
//
//  Created by İlknur Tulgar on 26.11.2024.
//

import SwiftUI

struct ChatUser: Identifiable {
    var id: String
    var username: String
    var message: String
    var unreadMessage: Int
    var profileImage: String?
    var topic: String?
    var role: String?
    var timestamp: Date?
    var users: [String]
    var lastMessage: String?
    
    func toDictionary() -> [String: Any] {
           return [
               "id": id,
               "username": username,
               "message": message,
               "unreadMessage": unreadMessage,
               "profileImage": profileImage ?? "",
               "topic": topic ?? "",
               "role": role ?? "",
               "timestamp": timestamp ?? Date(),
               "users": users,
               "lastMessage": lastMessage ?? ""
           ]
       }
}
