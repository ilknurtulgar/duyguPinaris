//
//  CustomPicker.swift
//  duyguPinari
//
//  Created by İlknur Tulgar on 19.11.2024.
//

import SwiftUI

struct CustomPicker<T: Hashable>: View {
    let subtitle: String
    @Binding var selection: T
    let options: [T]
    @State private var isExpanded = false
    var body: some View{
        VStack(alignment: .leading, spacing: 8){
            TextStyles.subtitleRegular(subtitle)
                .padding(.bottom,15)
            // seçilen değeri gösteren
            Button(action: {
                //dropdown menüsünü açıp kapatan
                withAnimation{isExpanded.toggle()}
                
            }){
                HStack{
                    TextStyles.subtitleMedium("\(selection)")
                        .padding(.leading,20)
                    Spacer()
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .foregroundColor(Color.textColor)
                        .padding(.trailing,20)
                }
                
                .frame(width: 295,height: 40)
                .background(Color.white)
                .cornerRadius(15)
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                    .stroke(Color.secondaryColor,lineWidth: 1)
                )
            }
            if isExpanded {
                VStack{
                    ForEach(options,id: \.self){ option in
                        Button(action:{
                            selection = option
                            withAnimation{
                                isExpanded = false
                            }
                        }){
                            TextStyles.subtitleRegular2("\(option)")
                                .padding(.leading,20)
                                .frame(maxWidth: .infinity,alignment: .leading)
                        }
                        .frame(width: 295,height: 40)
                        .background(Color.white)
                        .cornerRadius(15)
                        .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(Color.secondaryColor,lineWidth:1)
                        )
                    }
                }
            }
        }
    }
}
