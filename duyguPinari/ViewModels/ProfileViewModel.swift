//
//  ProfileViewModel.swift
//  duyguPinari
//
//  Created by İlknur Tulgar on 29.11.2024.
//

import SwiftUI
import FirebaseFirestore

class ProfileViewModel {
    
    private var db = Firestore.firestore()
    
    func updateTalkState(id:String,newTalkState: Bool,completion: @escaping (Result<Void,Error>) -> Void){
        db.collection("users").document(id).updateData(["talkState": newTalkState] ){
            error in
            if let error = error {
                print("talkstate didnt update")
                completion(.failure(error))
            }else{
                completion(.success(()))
            }
        }
        
    }
}
