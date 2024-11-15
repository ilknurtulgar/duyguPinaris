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
            VStack{
                CustomToolBar(title: "Geri Bildirimler", icon: Image(systemName: "chevron.left")){
                    dismiss()
                }
                .padding(.top,30)
                Spacer()
            }
        }
    }
}

#Preview {
    FeedbacksView()
}
