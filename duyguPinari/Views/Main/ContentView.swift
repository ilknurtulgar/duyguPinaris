//
//  ContentView.swift
//  duyguPinari
//
//  Created by İlknur Tulgar on 30.10.2024.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab: String? = "Home"
    @State private var isLoggedIn = false
    @State private var showBottomTabBar = true
    var body: some View {
        ZStack {
            Color.backgroundPrimary.ignoresSafeArea()
            if isLoggedIn {
                VStack(spacing:0) {
                    NavigationStack {
                        ZStack {
                            Color.backgroundPrimary.ignoresSafeArea()
                            if selectedTab == "Home" {
                                HomeView(showBottomTabBar: $showBottomTabBar)
                            } else if selectedTab == "Profile" {
                                ProfileView( showBottomTabBar: $showBottomTabBar)
                            }
                        }
                        .navigationBarHidden(true)
                    }

                    if showBottomTabBar {
                        BottomTabBar(selectedTab: $selectedTab)
                            .padding(.bottom, 10)
                    }
                }
            } else {
                LoginView(isLoggedIn: $isLoggedIn,showBottomTabBar: $showBottomTabBar)
            }
        }
    }
}



// Preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
