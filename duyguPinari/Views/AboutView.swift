//
//  AboutView.swift
//  duyguPinari
//
//  Created by İlknur Tulgar on 2.12.2024.
//

import SwiftUI


extension View {
    func asText() -> Text {
        guard let text = self as? Text else {
            fatalError("This view is not a Text instance.")
        }
        return text
    }
}

struct AboutView: View {
    @State var isActive: Bool
    @State var isDone: Bool = false
    @Environment(\.dismiss) private var dismiss
    @State private var showAlert: Bool = false

    var body: some View {
        NavigationStack{
            ZStack {
                Color.backgroundPrimary.ignoresSafeArea()
                VStack(spacing: 0) {
                    CustomToolBar(title: "chat", icon: Image(systemName: "chevron.left"), action: {
                        dismiss()
                        isActive = false // ChatView'e dönmek için
                    }, userImageURL: "", hasUserImage: true, titleAlignment: .leading, textAction: nil,paddingSize: 10)
                    
                    ScrollView {
                        VStack(spacing: 20) {
                            ProfileImage()
                                .padding(.top, 16)
                                .padding(.bottom,20)
                            TextStyles.subtitleMedium2("Hakkında:")
                                .frame(maxWidth: 430,alignment: .leading)
                                .padding(.leading,70)
                            TextStyles.bodyRegular("Teknoloji ve inovasyona ilgi duyan, her zaman yeni fikirler ve çözümler üretmeye odaklanan bir profesyoneldir. Hedef odaklı çalışarak karmaşık problemleri çözmeyi ve yenilikçi projelerde yer almayı sever. Sosyal etkileşimde güçlü, takım çalışmasına yatkın ve liderlik becerileriyle dikkat çeker. Zamanını verimli kullanarak kişisel ve profesyonel gelişimine yatırım yapar. Boş zamanlarında film izlemeyi, müzik dinlemeyi ve seyahat etmeyi tercih eder.")
                                .asText()
                                .customAboutText(backgroundColor: Color.white,borderColor: Color.secondaryColor,shadow: true)
                            
                            TextStyles.subtitleMedium2("Konu:")
                                .frame(maxWidth: 430,alignment: .leading)
                                .padding(.leading,70)
                            
                            TextStyles.bodyRegular("Sosyal Anksiyete")
                            
                                .asText()
                                .customAboutText(backgroundColor: Color.white,borderColor: Color.secondaryColor,shadow: true,isTopic: true)
                                .multilineTextAlignment(.leading)
                            CustomRedirectButton(icon: Image(systemName: "xmark"), title: "Konuşmayı Bitir", action: {
                                showAlert = true
                            },shadow: true)
                            .frame(maxWidth: 430,alignment: .leading)
                            .padding(.leading,70)
                            .padding(.top,15)
                            
                        }
                    }
                }
                .navigationDestination(isPresented: $isDone){
                    AddFeedbackView()
                        .navigationBarBackButtonHidden(true)
                }
                .alert("Konuşmayı Bitirme", isPresented: $showAlert) {
                    Button("Hayır", role: .cancel) { }
                    Button("Evet") {
                      isDone = true
                    }
                } message: {
                    Text("Konuşma silinecektir. Geri bildirim vermek ister misiniz?")
                }
            }
        }
    }
}




/*#Preview {
    AboutView()
}*/
