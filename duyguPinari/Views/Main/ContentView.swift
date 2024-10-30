//
//  ContentView.swift
//  duyguPinari
//
//  Created by İlknur Tulgar on 30.10.2024.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack{
            Color.backgroundPrimary.ignoresSafeArea()
            LoginUI()
        }
    }
}

#Preview {
    ContentView()
}
