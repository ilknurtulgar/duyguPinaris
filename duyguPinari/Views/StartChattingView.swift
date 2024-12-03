//
//  StartChattingView.swift
//  duyguPinari
//
//  Created by İlknur Tulgar on 19.11.2024.
//

import SwiftUI

struct StartChattingView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var navigateToNextView = false
    @Binding var showBottomTabBar: Bool
    @State var matchedUser: User?
    @EnvironmentObject var appState: AppState
    
    @StateObject private var viewModel = StartChattingViewModel()
    var body: some View {
        NavigationStack{
            ZStack{
                Color.backgroundPrimary.ignoresSafeArea()
                VStack(spacing:0){
                    CustomToolBar(title: StartChattingViewModel.StartChattingConstants.startConversation, icon:Image(systemName: "chevron.left"), action: {
                    showBottomTabBar = true
                        dismiss()
                    }, userImageURL: "",hasUserImage: false,titleAlignment: .center,textAction: {
                        
                    },paddingSize: 70)
                        .padding(.bottom,45)
                    
                    ScrollView{
                        VStack(){
                            TextStyles.subtitleMedium(StartChattingViewModel.StartChattingConstants.convesationInfo)
                                .padding(.bottom,30)
                            CustomPicker(subtitle: StartChattingViewModel.StartChattingConstants.ageSubtitle, selection: $viewModel.selectionAge, options: viewModel.agesList)
                                .padding(.bottom,40)
                            CustomPicker(subtitle: StartChattingViewModel.StartChattingConstants.topicTitle, selection: $viewModel.topic, options: viewModel.topicList)
                            
                            if let errorMessage = viewModel.errorMessage{
                                Text(errorMessage)
                                    .foregroundStyle(.red)
                            }
                        }
                    }
                    Spacer()
                    CustomButton(title: StartChattingViewModel.StartChattingConstants.find, width: 295, height: 40, backgroundColor: Color.primaryColor, borderColor: Color.primaryColor, textcolor: Color.white, action: {
                        if viewModel.validateSelections(){
                            viewModel.startChat()
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                viewModel.fetchMatchingListener(appState: appState){ result in
                                    switch result {
                                    case .success(let matchedUser):
                                        self.matchedUser = matchedUser
                                        if matchedUser != nil {
                                            navigateToNextView = true
                                        }else{
                                            viewModel.errorMessage = "Eşleşecek uygun bir kullanıcı bulunamadı. Lütfen daha sonra tekrar deneyin."
                                        }
                                    case .failure(let error):
                                        print(error.localizedDescription)
                                    }
                                }
                       
                            }
                            
                        }else{
                            viewModel.isLoading = false
                        }
                    }, font:   .custom("SFPro-Display-Medium", size: 15))
                    .padding(.bottom,30)
                }
                if viewModel.isLoading{
                    ZStack{
                        Color.gray.opacity(0.7).ignoresSafeArea()
                        VStack(spacing: 20){
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: Color.primaryColor))
                                .scaleEffect(1.5)
                            Text(StartChattingViewModel.StartChattingConstants.loadingTitle)
                                .font(.custom("SFPro-Display-Medium", size: 20))
                                .foregroundColor(Color.white)
                        }
                    }
                }
            }
            .navigationDestination(isPresented: $navigateToNextView){
                SelectConversationView(matchedUser: $matchedUser, appState: _appState, showBottomTabBar: $showBottomTabBar,topic: viewModel.topic)
                    .onAppear{
                        showBottomTabBar = false
                    }
                    .navigationBarHidden(true)
            }
        }
    }
}

/*#Preview {
 StartChattingView()
 }*/
