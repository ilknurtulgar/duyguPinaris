//
//  HomeView.swift
//  duyguPinari
//
//  Created by İlknur Tulgar on 6.11.2024.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        VStack{
            HStack{
                Spacer()
                AddConversationButton(action: {})
                    .padding(.top,10)
                    .padding(.trailing,45)
            }
            FeedbackCard(profileImage: Image(systemName: "person.fill"), name: "ilknur", role: "listener", rating: 2, feedbackText: "ı love you")
        }
    }
}
#Preview {
    HomeView()
}

