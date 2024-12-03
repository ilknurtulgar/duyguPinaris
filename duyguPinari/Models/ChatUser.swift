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
}
