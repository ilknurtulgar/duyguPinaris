//
//  ContentView.swift
//  duyguPinari
//
//  Created by İlknur Tulgar on 30.10.2024.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

class AppState: ObservableObject {
    @Published var isLoggedIn = false
    @Published var selectedTab: String = "Home"
    @Published var currentUser: User?
    @Published var isLoading: Bool = false // Veri yükleniyor durumu
    
    init() {
        if let _ = Auth.auth().currentUser {
            fetchUserProfile()
        }
    }
    
    func fetchUserProfile() {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        let db = Firestore.firestore()
        
        self.isLoading = true // Yükleme başladığında loading durumu aktif
        db.collection("users").document(userID).getDocument { (document, error) in
            if let document = document, document.exists {
                let data = document.data()
                let id = data?["id"] as? String ?? ""
                let username = data?["username"] as? String ?? ""
                let email = data?["email"] as? String ?? ""
                let age = data?["age"] as? String ?? ""
                let password = data?["password"] as? String ?? ""
                let about = data?["about"] as? String ?? ""
                self.currentUser = User(id: id, username: username, email: email, age: age, password: password,about: about)
            }
            self.isLoading = false // Veri yüklendikten sonra loading durumu false
        }
    }
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
