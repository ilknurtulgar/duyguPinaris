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
    var chatUser: ChatUser
    @State private var newMessage: String = ""
    @State private var aboutNavigate = false
    var shadow: Bool = false
    @State private var aboutText: String = "Hakkında bilgisi mevcut değil."
    @EnvironmentObject var appState: AppState
    @StateObject var viewModel = ChatViewModel()

    var body: some View {
        NavigationStack {
            ZStack {
                Color.backgroundPrimary.ignoresSafeArea()
                VStack(spacing: 0) {
                    CustomToolBar(title: chatUser.username, icon: Image(systemName: "chevron.left"), action: {
                        appState.homeViewModel?.fetchChatUsers(for: appState.currentUser?.id ?? "") {
                            print("HomeView'a dönmeden önce chat users güncellendi")
                        }
                        showBottomTabBar = true
                        dismiss()
                    }, userImageURL: chatUser.profileImage ?? "", hasUserImage: true, titleAlignment: .leading, textAction: {
                        aboutNavigate = true
                    }, paddingSize: 10)

                    ScrollViewReader { proxy in
                        ScrollView {
                            VStack(spacing: 15) {
                                ForEach(viewModel.messages) { message in
                                    CustomGetMessage(
                                        message: message.content,
                                        isCurrentUser: message.senderID == appState.currentUser?.id ?? "",
                                        profileImageURL: chatUser.profileImage ?? "",
                                        time: getCurrentTime(for: message.timestamp)
                                    )
                                    .id(message.id)
                                }
                            }
                            .padding(.horizontal)
                            .padding(.top,10)
                          
                        }
                        .onAppear {
                            // Sayfa yüklendiğinde en son mesaja kaydır
                            if let lastMessageId = viewModel.messages.last?.id {
                                proxy.scrollTo(lastMessageId, anchor: .bottom)
                            }
                        }
                        // iOS 17'ye uygun şekilde onChange ile eski ve yeni değeri alıyoruz
                        .onChange(of: viewModel.messages) { oldValue, newValue in
                            if newValue.count > oldValue.count {  // Yeni bir mesaj geldiğinde
                                if let lastMessageId = newValue.last?.id {
                                    DispatchQueue.main.async {
                                        proxy.scrollTo(lastMessageId, anchor: .bottom)
                                    }
                                }
                            }
                        }
                    }

                    SendMessageField(newMessage: $newMessage) {
                        if !newMessage.isEmpty {
                            let newMessageObject = ChatMessage(
                                id: UUID().uuidString,
                                content: newMessage,
                                senderID: appState.currentUser?.id ?? "",
                                timestamp: Date()
                            )
                            viewModel.messages.append(newMessageObject)
                            viewModel.sendMessage(to: chatUser.id, messageContent: newMessage, currentUserId: appState.currentUser?.id ?? "")
                            viewModel.updateLastMessage(for: chatUser.id, newMessage: newMessage, currentUserId: appState.currentUser?.id ?? "")
                            newMessage = ""
                        }
                    }
                    .padding(.top,10)
                }
                .navigationDestination(isPresented: $aboutNavigate) {
                    AboutView( showBottomTabBar: $showBottomTabBar,chatUser: chatUser,about: aboutText)
                        .environmentObject(appState)
                        .navigationBarBackButtonHidden(true)
    
                        .onDisappear{
                            aboutNavigate = false
                        
                        }
                    
                }
                .onAppear {
                    viewModel.fetchMessages(for: chatUser.id, currentUserId: appState.currentUser?.id ?? "")
                    viewModel.fetchAbout(for: chatUser.id) { about in
                            if let about = about {
                                self.aboutText = about
                            }
                        }
                    viewModel.resetUnreadMessages(for: appState.currentUser?.id ?? "",chatUserId:chatUser.id,chatUser: chatUser)
                }
             
            }
        }
    }

    private func getCurrentTime(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter.string(from: date)
    }
}


    
    
    /*#Preview {
     ChatView()
     }*/
