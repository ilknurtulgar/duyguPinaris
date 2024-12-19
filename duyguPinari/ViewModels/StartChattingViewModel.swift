//
//  StartChattingViewModel.swift
//  duyguPinari
//
//  Created by İlknur Tulgar on 19.11.2024.
//

import SwiftUI
import FirebaseFirestore

class StartChattingViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    @Published  var selectionAge = ""
    @Published  var topic = ""
    @Published var errorMessage: String? = nil
    //eşleşen kullanıcı
    @Published var matchedUser: User? = nil

    struct StartChattingConstants {
        static let validateMessage = "Lütfen tüm alanları doldurun."
        static let startConversation = "Konuşma Başlat"
        static let ageSubtitle = "Yaş aralığı seçin:"
        static let roleSubtitle = "Konuşma rolünü seçin:"
        static let topicTitle = "Konu seçiniz:"
        static let find = "Bul"
        static let loadingTitle = "Oluşturuluyor, lütfen bekleyin..."
        static let convesationInfo = "Anlatmak istediğiniz konuyu ve yaş aralığını seçiniz."
    }
    
    let agesList = ["18 - 30","31 - 45","46 - 60"]
    let topicList = ["Stres ve Anksiyete","İlişki Sorunları","Kaygı ve Kayıp","İş Yerinde Stres","Yalnızlık","Aile İlişkileri","Sosyal Anksiyete","Ebeveynlik Zorlukları","Hayat ve Kariyer Dengesi"]
    
    
    func validateSelections() -> Bool {
        if selectionAge.isEmpty || topic.isEmpty{
            errorMessage = StartChattingConstants.validateMessage
            return false
        }
        return true
    }
    
    func startChat()  {
        isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0){
            self.isLoading = false
        }
    }
    
    let db = Firestore.firestore()
    
    //firestoredan uygun kullanıcıyı getirmek için
    func fetchMatchingListener(appState: AppState,completion: @escaping (Result<User?,Error>) -> Void){
        //kullanıcı seçimlerini kontrol et
        guard validateSelections() else {
            completion(.failure(NSError(domain: "", code: -1,userInfo: [NSLocalizedDescriptionKey: "Seçimler yapılmadı."])))
            return
        }
        startChat()
        //print("startcurrentUser: \(String(describing: appState.currentUser))")
        guard let  currentUser = appState.currentUser else{
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Geçerli kullanıcı bulunamadı."])))
            return
        }
        // yaş aralığını ayırma
        let selectedRange = selectionAge.split(separator: "-").compactMap{ Int($0.trimmingCharacters(in: .whitespaces))}
        
        guard selectedRange.count == 2 else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Yaş aralığı geçersiz."])))
            return
        }
        let minAge = selectedRange[0]
        let maxAge = selectedRange[1]
        
        let minAgeString = String(minAge)
        let maxAgeString = String(maxAge)
        // sorgulama
        db.collection("users")
            .whereField("age", isGreaterThanOrEqualTo: minAgeString)
            .whereField("age", isLessThanOrEqualTo: maxAgeString)
            .getDocuments{snapshot, error in
                DispatchQueue.main.async{
                    self.isLoading = false
                }
                if let error = error {
                    completion(.failure(error))
                    return
                }

                
                guard let documents = snapshot?.documents, !documents.isEmpty else {
                    DispatchQueue.main.async {
                        self.errorMessage = "Eşleşecek uygun bir kullanıcı bulunamadı.\n Lütfen daha sonra tekrar deneyin."
                    }
                    completion(.success(nil))
                    return
                }
                // yaş aralığına uygun kullanıcıları filtreleme talkstate true olanı bulma
                let matchingUsers = documents.compactMap{document -> User? in
                    let data = document.data()
                    guard let ageString  = data["age"] as? String,
                          let userAge = Int(ageString),
                          userAge >= minAge && userAge <= maxAge else{
                        return nil
                    }
                    
                    // talkState ture olanı döndür
                    guard let talkState = data["talkState"] as? Bool, talkState == true else {
                        return nil
                    }
                    return User(id: document.documentID, username: data["username"] as? String ?? "", email: data["email"] as? String ?? "", age: ageString, password: "",about: data["about"] as? String,talkState: talkState,profileImageURL: data["profileImageURL"] as? String)
                }
                
                //currentUser listenin dışına ekleme
              //  print("chatUsers: \(String(describing: appState.chatUsers.first))")
                let filteredUsers = matchingUsers.filter { user in
                    return user.id != currentUser.id && !appState.chatUsers.contains { $0.id == user.id }
                          }
                if filteredUsers.isEmpty{
                    DispatchQueue.main.async {
                        self.errorMessage = "Eşleşecek uygun bir kullanıcı bulunamadı. Lütfen daha sonra tekrar deneyin."
                    }
                    print("eşleşen kullanıcı bulunamadı")
                    completion(.success(nil))
                }else{
                    // kullanıcı seçme
                    let randomUser = filteredUsers.randomElement()
                    
                    if let matchedUser = randomUser{
        
                        completion(.success(matchedUser))
                    }else{
                        completion(.success(nil))
                    }
                    
                    
                }
              
            }
    }
}
