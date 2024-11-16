//
//  FeedbacksView.swift
//  duyguPinari
//
//  Created by İlknur Tulgar on 14.11.2024.
//

import SwiftUI

struct FeedbacksView: View {
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        ZStack{
            Color.backgroundPrimary.ignoresSafeArea()
            VStack(){
                CustomToolBar(title: "Geri Bildirimler", icon: Image(systemName: "chevron.left")){
                    dismiss()
                }
                ScrollView{
                    VStack{
                        FeedbackCard(
                            profileImage: Image(systemName: "person.circle"),
                            name: "Alexa Richardson",
                            role: "Listener",
                            rating: 3,
                            feedbackText: "Great conversation! Overall, I enjoyed chatting with you!"
                        )
                    }
                }
            }
        }
    }
}

#Preview {
    FeedbacksView()
}
