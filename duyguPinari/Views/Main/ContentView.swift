//
//  ContentView.swift
//  duyguPinari
//
//  Created by İlknur Tulgar on 30.10.2024.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var appState = AppState()
    @State private var showBottomTabBar = true
    var body: some View {
        ZStack {
            Color.backgroundPrimary.ignoresSafeArea()

            if appState.isLoggedIn {
                VStack(spacing:0) {
                    NavigationStack {
                        ZStack {
                          
                            if appState.selectedTab == "Home" {
                                HomeView(showBottomTabBar: $showBottomTabBar, appState: appState)
                                    .environmentObject(appState)
                                   
                            } else if appState.selectedTab == "Profile" {
                                ProfileView( showBottomTabBar: $showBottomTabBar)
                                    .environmentObject(appState)
                            }
                        }
                        .navigationBarHidden(true)
                    }

                    if showBottomTabBar {
                        BottomTabBar(selectedTab: $appState.selectedTab)
                            .padding(.bottom, 10)
                    }
                 
                }
            } else {
                LoginView(appState: appState,showBottomTabBar: $showBottomTabBar)
                    .environmentObject(appState)
                   
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
