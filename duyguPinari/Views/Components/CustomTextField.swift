//
//  CustomTextField.swift
//  duyguPinari
//
//  Created by İlknur Tulgar on 5.11.2024.
//

import SwiftUI

struct CustomTextField: View {
    @Binding var text: String
    @State private var isPasswordVisible: Bool = false
    var placeholder: String
    var isSecure: Bool = false
    var isAbout: Bool = false
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
            HStack{
                if isPasswordVisible{
                    TextField(placeholder,text: $text)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                }else{
                    SecureField(placeholder,text: $text)
                }
                Button(action: {
                    isPasswordVisible.toggle()
                }){
                    Image(systemName: isPasswordVisible ? "eye.slash" : "eye")
                        .frame(width: 18,height: 14)
                        .foregroundColor(Color.unselectedColor)
                        .padding(.trailing,15)
                }
                    
            }
        }else if isAbout{
            TextEditor(text: $text)
                .autocapitalization(.none)
                .disableAutocorrection(true)
        }else{
            TextField(placeholder,text:$text)
                .autocapitalization(.none)
                .disableAutocorrection(true)
        }
    }
}

