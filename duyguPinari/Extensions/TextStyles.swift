//
//  TextStyles.swift
//  duyguPinari
//
//  Created by İlknur Tulgar on 4.11.2024.
//

import Foundation

import SwiftUI

//medium 50 hugetitle
//medium 20 title
//regular 10 body
//subtitle medium 15
//subtitle2 regular 12 // bu olursa ekleme
struct TextStyles {
    
    static func hugeTitle(_ text: String) -> some View {
        Text(text)
            .font(.custom("SFPro-Display-Medium", size: 50))
            .foregroundColor(.textColor)
    }
    static func title(_ text: String) -> some View {
        Text(text)
            .font(.custom("SFPro-Display-Medium", size: 20))
            .foregroundColor(.textColor)
    }
    static func bodyMediumSelected(_ text: String) -> some View {
        Text(text)
            .font(.custom("SFPro-Display-Medium", size: 10))
            .foregroundColor(.textColor)
    }
    static func bodyMediumUnselected(_ text: String) -> some View {
        Text(text)
            .font(.custom("SFPro-Display-Medium", size: 10))
            .foregroundColor(.unselectedColor)
    }
    static func bodyRegular(_ text: String) -> some View {
        Text(text)
            .font(.custom("SFPro-Display-Regular", size: 10))
            .foregroundColor(.textColor)
    }
    
    static func subtitleMedium(_ text: String) -> some View {
        Text(text)
            .font(.custom("SFPro-Display-Medium", size: 15))
            .foregroundColor(.textColor)
    }
    static func subtitleRegular(_ text:String) -> some View {
        Text(text)
            .font(.custom("SFPro-Display-Regular", size: 15))
            .foregroundColor(.textColor)
    }
    
    static func subtitleRegular2(_ text:String) -> some View {
        Text(text)
            .font(.custom("SFPro-Display-Regular", size: 12))
            .foregroundColor(.secondary)
    }
    
    
}
