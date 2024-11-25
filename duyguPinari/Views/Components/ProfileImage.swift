//
//  ProfileImage.swift
//  duyguPinari
//
//  Created by İlknur Tulgar on 7.11.2024.
//

import SwiftUI


struct ProfileImage: View {
    var body: some View {
       Image(systemName: "person.circle")
            .resizable()
            .scaledToFit()
            .frame(width: 244, height: 230)  // Boyutu ayarlayın
            .clipShape(Circle()) // Yuvarlak şekilde göster
            .overlay(RoundedRectangle(cornerRadius: 30))
    }
}
