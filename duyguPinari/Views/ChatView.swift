//
//  ChatView.swift
//  duyguPinari
//
//  Created by İlknur Tulgar on 19.11.2024.
//

import SwiftUI

struct ChatView: View {
    @Binding var showBottomTabBar: Bool
    @Environment(\.dismiss) private var dismiss
    @State private var newMessage: String = ""
    @State private var messages: [(content: String, isCurrentUser: Bool, time: String)] = [
        ("Hello!", false, "7:30 PM"),
        ("How are you?", true, "7:31 PM"),
        ("I'm good, thanks!", false, "7:32 PM"),
        ("What about you?", true, "7:33 PM")
    ]
    @State private var aboutNavigate = false

    var body: some View {
        NavigationStack {
            ZStack {
                Color.backgroundPrimary.ignoresSafeArea()
                VStack(spacing: 0) {
                    CustomToolBar(title: "chat", icon: Image(systemName: "chevron.left"), action: {
                        showBottomTabBar = true
                        dismiss()
                    }, userImageURL: "", hasUserImage: true, titleAlignment: .leading, textAction: {
                        aboutNavigate = true
                    },paddingSize: 10)

                    ScrollView {
                        VStack(spacing: 12) {
                            ForEach(messages.indices, id: \.self) { index in
                                let message = messages[index]
                                CustomGetMessage(
                                    message: message.content,
                                    isCurrentUser: message.isCurrentUser,
                                    time: message.time
                                )
                            }
                        }
                        .padding(.horizontal)
                    }

                    SendMessageField(newMessage: $newMessage) {
                        if !newMessage.isEmpty {
                            messages.append((content: newMessage, isCurrentUser: true, time: getCurrentTime()))
                            newMessage = ""
                        }
                    }
                }
            }
            .navigationDestination(isPresented: $aboutNavigate) {
                AboutView(isActive: aboutNavigate)
                    .navigationBarBackButtonHidden(true)
            }
        }
    }

    private func getCurrentTime() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter.string(from: Date())
    }
}



/*#Preview {
    ChatView()
}*/
