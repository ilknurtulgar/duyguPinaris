//
//  RatingView.swift
//  duyguPinari
//
//  Created by İlknur Tulgar on 3.12.2024.
//

import SwiftUI

struct RatingView: View {
    @Binding var rating: Int
    let maxRating: Int = 5
    let starSize: CGFloat = 30
    
    var body: some View {
        HStack(spacing: 10) {
            ForEach(1...maxRating, id: \.self) { index in
                Image(systemName: index <= rating ? "star.fill" : "star")
                    .resizable()
                    .scaledToFit()
                    .frame(width: starSize, height: starSize)
                    .foregroundColor(index <= rating ? Color.primaryColor : Color.gray) 
                    .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2) // Gölge
                    .onTapGesture {
                        if rating == index {
                            rating = 0 // Aynı yıldıza tıklanırsa sıfırlanır
                        } else {
                            rating = index // Yeni yıldız değeri atanır
                        }
                    }
            }
        }
    }
}


