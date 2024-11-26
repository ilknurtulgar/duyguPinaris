//
//  BottomTabBar.swift
//  duyguPinari
//
//  Created by İlknur Tulgar on 7.11.2024.
//

import Foundation
import SwiftUI


struct BottomTabBar: View {
    @Binding var selectedTab: String
    
    var body: some View {
        HStack {
            Spacer()
            // Home Tab
            Button(action: {
                selectedTab = "Home"
            }) {
                VStack {
                    Image(systemName: "house.fill")
                        .font(.system(size: 20))
                        .foregroundColor(selectedTab == "Home" ? Color.textColor : Color.unselectedColor)
                    if selectedTab == "Home" {
                        TextStyles.bodyMediumSelected("Ana Sayfa")
                    } else {
                        TextStyles.bodyMediumUnselected("Ana Sayfa")
                    }
                }
                .padding(.top, 10)
                .padding(.bottom, 5)
            }
            .frame(maxWidth: 50, maxHeight: 50)
            
            Spacer()
            
            // Profile Tab
            Button(action: {
                selectedTab = "Profile"
            }) {
                VStack {
                    Image(systemName: "person.fill")
                        .font(.system(size: 25))
                        .foregroundColor(selectedTab == "Profile" ? Color.textColor : Color.unselectedColor)
                    if selectedTab == "Profile" {
                        TextStyles.bodyMediumSelected("Profil")
                    } else {
                        TextStyles.bodyMediumUnselected("Profil")
                    }
                }
                .padding(.top, 10)
                .padding(.bottom, 5)
            }
            .frame(maxWidth: 50, maxHeight: 50)
            
            Spacer()
        }
        .padding(.horizontal)
        .frame(width: 330, height: 65)
        .background(Color.white)
        .cornerRadius(30)
        .padding(.horizontal, 98)
    }
}


