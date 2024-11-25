//
//  FeedbacksView.swift
//  duyguPinari
//
//  Created by İlknur Tulgar on 14.11.2024.
//

import SwiftUI

struct FeedbacksView: View {
    @StateObject var viewModel = FeedbacksViewModel()
    @Binding var showBotttomTabBar: Bool
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        ZStack{
            Color.backgroundPrimary.ignoresSafeArea()
            VStack(){
                CustomToolBar(title: "Geri Bildirimler", icon: Image(systemName: "chevron.left")){
                    dismiss()
                    showBotttomTabBar = true
                }
                .padding(.bottom,30)
                ScrollView{
                    VStack(spacing: 30){
                        ForEach(viewModel.feedbacks){ feedback in
                            FeedbackCard(profileImage: feedback.profileImage, name: feedback.name, role: feedback.role, rating: feedback.rating, feedbackText: feedback.feedbackText)
                            
                        }
                    }
                }
            }
        }
    }
}

/*#Preview {
    FeedbacksView()
}*/
