//
//  duyguPinariApp.swift
//  duyguPinari
//
//  Created by İlknur Tulgar on 30.10.2024.
//

import SwiftUI

@main
struct duyguPinariApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject private var appState = AppState()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appState)
        }
    }
}
