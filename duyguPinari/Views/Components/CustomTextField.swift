//
//  CustomTextField.swift
//  duyguPinari
//
//  Created by İlknur Tulgar on 5.11.2024.
//

import Foundation
import SwiftUI

struct CustomTextField: View {
    var placeholder: String
    @Binding var text:String
    var isSecure: Bool = false
    var isAbout: Bool=false
    var keyboardType: UIKeyboardType = .default
    var subtitle: String? = nil
    var body: some View {
        VStack(alignment: .leading) {
            if let subtitle = subtitle, !subtitle.isEmpty {
                TextStyles.subtitleRegular(subtitle)
                    .padding(.bottom,15)
            }
            
            Group {
                inputField
                    .padding(.leading, 10)
                    .frame(width: 295,  height: isAbout ? 300 :40)
                    .background(Color.white)
                    .keyboardType(keyboardType)
                    .cornerRadius(15)
                    .foregroundColor(Color.textColor)
                    .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(Color.secondaryColor, lineWidth: 1)
                    )
            }
        }
        .padding(.vertical,20)
        
    }
    
    @ViewBuilder
    private var inputField: some View{
        if isSecure
        {
            SecureField(placeholder,text: $text)
        }else if isAbout{
            TextEditor(text: $text)
        }else{
            TextField(placeholder,text:$text)
        }
    }
}

