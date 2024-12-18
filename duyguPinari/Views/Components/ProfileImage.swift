//
//  ProfileImage.swift
//  duyguPinari
//
//  Created by İlknur Tulgar on 7.11.2024.
//

import SwiftUI

struct ProfileImage: View {
    var imageURL: String?

    var body: some View {
        if let imageURL = imageURL, let url = URL(string: imageURL) {
            AsyncImage(url: url) { phase in
                switch phase {
                case .empty:
                    // Placeholder göster
                    Image(systemName: "person.circle")
                        .resizable()
                        .scaledToFit()
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFit()
                case .failure:
                    // Yükleme başarısız olduysa alternatif bir placeholder göster
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .scaledToFit()
                @unknown default:
                    EmptyView()
                }
            }
            .frame(width: 220, height: 220)
            .clipShape(Circle())
            .overlay(Circle().stroke(Color.gray, lineWidth: 1))
        } else {
            // Görsel URL'si yoksa da bir placeholder göster
            Image(systemName: "person.circle")
                .resizable()
                .scaledToFit()
                .frame(width: 244, height: 230)
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.gray, lineWidth: 1))
        }
    }
}
