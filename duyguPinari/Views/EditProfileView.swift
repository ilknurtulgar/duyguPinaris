//
//  EditProfileView.swift
//  duyguPinari
//
//  Created by İlknur Tulgar on 14.11.2024.
//

import SwiftUI

struct EditProfileView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var showBottomTabBar: Bool
    
    @State private var username: String = "alexa"
    @State private var email: String = "alexa@example.com"
    @State private var age: String = "15.10.1997"
    @State private var about: String = "sacdcdövdöşwedbwsüdflçöeğrldfacdcdövdöşwedbwsüdflçöeğrldfacdcdövdöşwedbwsüdflçöeğrldfacdcdövdöşwedbwsüdflçöeğrldfacdcdövdöşwedbwsüdflçöeğrldfacdcdövdöşwedbwsüdflçöeğrldfacdcdövdöşwedbwsüdflçöeğrldf"
    
    var body: some View {
        ZStack{
            Color.backgroundPrimary.ignoresSafeArea()
            VStack(spacing:0){
                CustomToolBar(title: "Profil Düzenleme",  icon: Image(systemName: "chevron.left")){
                    dismiss()
                }
                .padding(.top,30)
                
                ScrollView{
                    VStack(spacing:16){
                        ProfileImage()
                            .padding(.top,16)
                        CustomTextField(placeholder: "Alexa Richardson", text: $username,subtitle: "UserName:")
                        CustomTextField(placeholder: "alexa@example.com", text: $email,subtitle: "E mail:")
                        CustomTextField(placeholder: "15.10.1997", text: $age,subtitle: "Age:")
                        CustomTextField(placeholder: "Alexa Richardson", text: $about,isAbout: true,subtitle: "About:")
                    }
                }
            }
        }
       /* .onAppear {
            showBottomTabBar = false
        }
        
        .onDisappear {
            showBottomTabBar = true
        }*/
    }
}

/*#Preview {
 EditProfileView()
 }*/

