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
    var body: some View {
        ZStack{
            
            Color.backgroundPrimary.ignoresSafeArea()
            VStack(spacing: 0) {
                CustomToolBar(title: "Chat view", icon: Image(systemName: "chevron.left")){
                    dismiss()
                }
                VStack{
                    Text("asas")
                }
                .padding(.top, 24)
                .padding(.bottom, 40)
            }
            .onAppear{
                showBottomTabBar = false
            }
            .onDisappear{
                showBottomTabBar = true
            }
        }
    }
}

/*#Preview {
    ChatView()
}*/
