//
//  SelectConversationView.swift
//  duyguPinari
//
//  Created by İlknur Tulgar on 19.11.2024.
//

import SwiftUI

struct SelectConversationView: View {
    var body: some View {
        ZStack{
            Color.backgroundPrimary.ignoresSafeArea()
            VStack(spacing: 0){
                CustomToolBar(title: "Konuşma Seç",icon: nil,action: nil)
                    .padding(.bottom,45)
                ScrollView{
                    VStack{
                        Text("hi")
                    }
                }
            }
            
        }
    }
}

#Preview {
    SelectConversationView()
}
