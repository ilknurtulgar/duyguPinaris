//
//  FeedbackCard.swift
//  duyguPinari
//
//  Created by İlknur Tulgar on 15.11.2024.
//

import SwiftUI

struct FeedbackCard: View {
    var profileImage: Image
    var name: String
    var role: String
    var rating: Int
    var feedbackText: String
    
    var body: some View{
        HStack(alignment: .top,spacing: 10){
            profileImage
                .resizable()
                .frame(width: 32,height: 35)
                .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
            VStack(alignment: .leading,spacing: 4){
                TextStyles.subtitleMedium(name)
                    .frame(maxWidth: .infinity, alignment: .leading)
                HStack(spacing: 8){
                    TextStyles.roleSubtitleRegular(role)
                    HStack(spacing:2){
                        ForEach(0..<rating, id:\.self){_ in
                            Image(systemName: "star.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 12,height: 12)
                            .foregroundColor(  Color.primaryColor)
                            .shadow(color: Color.black.opacity(0.5), radius: 4, x: 0, y: 2)
                        }
                    }
                }
                .padding(.bottom,13)
            
                TextStyles.subtitleMedium2(feedbackText)
                    .lineLimit(nil)
                    .multilineTextAlignment(.leading)
                
            }
        }
        .padding(12)
        .frame(width: 330)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .stroke(Color.primaryColor,lineWidth: 1)
                .background(Color.white.cornerRadius(15))
                .shadow(color: Color.gray.opacity(0.2), radius: 5, x: 0 ,y: 5)
        )
    }
}
