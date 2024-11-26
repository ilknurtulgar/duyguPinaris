//
//  ContentView.swift
//  duyguPinari
//
//  Created by İlknur Tulgar on 30.10.2024.
//

import SwiftUI


class AppState: ObservableObject {
    @Published var isLoggedIn = false
    @Published var selectedTab: String = "Home"
}


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
                            Color.backgroundPrimary.ignoresSafeArea()
                            if appState.selectedTab == "Home" {
                                HomeView(showBottomTabBar: $showBottomTabBar)
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
                LoginView(showBottomTabBar: $showBottomTabBar)
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
