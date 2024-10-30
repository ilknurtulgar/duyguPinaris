//
//  LoginUI.swift
//  duyguPinari
//
//  Created by İlknur Tulgar on 4.11.2024.
//

//Vstack kullanacağım
import SwiftUI

struct LoginUI: View {
    var body: some View {
        VStack{
           // Spacer().frame(height: 100)
            AuthTitle(title: "SIGN.", subtitle: "IN")
            Spacer()
        }
        .frame(maxWidth: .infinity,maxHeight: .infinity)
            .padding(.top,100)
        }
}

#Preview {
    LoginUI()
}

