//
//  StartChattingViewModel.swift
//  duyguPinari
//
//  Created by İlknur Tulgar on 19.11.2024.
//

import SwiftUI

class StartChattingViewModel: ObservableObject {
    @Published  var selectionAge = ""
    @Published  var selectionRole = ""
    @Published  var topic = ""
    @Published var errorMessage: String? = nil
    
    struct StartChattingConstants {
        static let validateMessage = "Lütfen tüm alanları doldurun."
        static let startConversation = "Konuşma Başlat"
        static let ageSubtitle = "Yaş aralığı seçin:"
        static let roleSubtitle = "Konuşma rolünü seçin:"
        static let topicTitle = "Konu seçiniz:"
        static let find = "Bul"
    }
    let agesList = ["18 - 30","31 - 45","46 - 60"]
    let roleList = ["Dinleyici", "Anatıcı"]
    let topicList = ["Stres ve Anksiyete","İlişki Sorunları","Kaygı ve Kayıp","İş Yerinde Stres","Yalnızlık","Aile İlişkileri","Sosyal Anksiyete","Ebeveynlik Zorlukları","Hayat ve Kariyer Dengesi"]
    
    func validateSelections() -> Bool {
        if selectionAge.isEmpty || selectionRole.isEmpty || topic.isEmpty{
            errorMessage = StartChattingConstants.validateMessage
            return false
        }
        return true
    }
}
