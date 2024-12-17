//
//  FeedbacksView.swift
//  duyguPinari
//
//  Created by İlknur Tulgar on 14.11.2024.
//

import SwiftUI

struct FeedbacksView: View {
    @StateObject var viewModel: FeedbacksViewModel
    @Binding var showBotttomTabBar: Bool
    @Environment(\.dismiss) private var dismiss
    
    init(appState: AppState, showBottomTabBar: Binding<Bool>) {
           _viewModel = StateObject(wrappedValue: FeedbacksViewModel(appState: appState))
           self._showBotttomTabBar = showBottomTabBar // Doğrudan atama, burada doğru.
       }
    
    var body: some View {
        NavigationStack{
            ZStack{
                Color.backgroundPrimary.ignoresSafeArea()
                VStack(){
                    CustomToolBar(title: "Geri Bildirimler", icon: Image(systemName: "chevron.left"),action: { dismiss()
                        showBotttomTabBar = true},userImageURL: "",hasUserImage: false,titleAlignment: .center,textAction: {
                            
                        },paddingSize: 70)
                    .padding(.bottom,30)
                    ScrollView{
                        VStack(spacing: 30){
                            ForEach(viewModel.feedbacks){ feedback in
                                FeedbackCard(profileImageURL: feedback.profileImage, name: feedback.username, role: feedback.role, rating: feedback.rating, feedbackText: feedback.feedbackText)
                                
                            }
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
