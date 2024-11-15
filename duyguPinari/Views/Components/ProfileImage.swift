//
//  ProfileImage.swift
//  duyguPinari
//
//  Created by İlknur Tulgar on 7.11.2024.
//

import SwiftUI
import SDWebImageSwiftUI

struct ProfileImage: View {
    var body: some View {
        WebImage(url: URL(string: "https://www.brit.co/media-library/jennifer-aniston-rachel-green-friends.jpg?id=35237685&width=600&height=600&quality=90&coordinates=0%2C0%2C0%2C3"))
            .resizable()
            .scaledToFit()
            .frame(width: 244, height: 230)  // Boyutu ayarlayın
            .clipShape(Circle()) // Yuvarlak şekilde göster
            .overlay(RoundedRectangle(cornerRadius: 30))
    }
}
