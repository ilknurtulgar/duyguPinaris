//
//  AddConversationButton.swift
//  duyguPinari
//
//  Created by İlknur Tulgar on 18.11.2024.
//

import SwiftUI

struct AddConversationButton: View {
    let action: () ->  Void
    var body: some View {
        Button(action:{action()}){
            Image(systemName: "plus.bubble")
                .frame(width: 50,height: 50)
                .foregroundColor(Color.primaryColor)
                .background(Color.white)
                .cornerRadius(15)
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(Color.primaryColor, lineWidth: 1)
                        .shadow(color: Color.gray.opacity(0.2), radius: 4,x:0,y:2)
                )
        }
        
    }
}
