//
//  SendMessageField.swift
//  duyguPinari
//
//  Created by İlknur Tulgar on 2.12.2024.
//

import SwiftUI

struct SendMessageField: View {
    @Binding var newMessage: String
    var onSend: () -> Void
    
    var body: some View{
        VStack(spacing: 5){
            
            Rectangle()
                .frame(height: 1)
                .foregroundColor(.secondaryColor)
            HStack{
                CustomTextField(text: $newMessage, placeholder: "")
                
                Button(action: {
                    if !newMessage.isEmpty{
                    onSend()
                    }
                }){
                    Image(systemName: "paperplane.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 35,height: 35)
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(.white,Color.primaryColor)
                }
            }
           
            
        }
    }
}
