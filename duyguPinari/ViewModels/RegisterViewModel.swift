//
//  RegisterViewModel.swift
//  duyguPinari
//
//  Created by İlknur Tulgar on 17.11.2024.
//

import SwiftUI

class RegisterViewModel: ObservableObject{
    @Published var username: String = ""
    @Published var email: String = ""
    @Published var age: String = ""
    @Published var password: String = ""
    private var registeredUsers:[User]=[]
    func registerUser(){
        let newUser=User(username: username, email: email, age: age, password: password)
        registeredUsers.append(newUser)
        print("yeni kullanıcı:\(newUser.username),\(newUser.email)")
    }
}
