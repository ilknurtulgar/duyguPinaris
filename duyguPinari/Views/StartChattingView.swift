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
    @StateObject private var viewModel = StartChattingViewModel()
    var body: some View {
        NavigationStack{
            ZStack{
                Color.backgroundPrimary.ignoresSafeArea()
                VStack(spacing:0){
                    CustomToolBar(title: StartChattingViewModel.StartChattingConstants.startConversation, icon:Image(systemName: "chevron.left"), action: {
                    showBottomTabBar = true
                        dismiss()
                    })
                        .padding(.bottom,45)
                    
                    ScrollView{
                        VStack(spacing:45){
                            CustomPicker(subtitle: StartChattingViewModel.StartChattingConstants.ageSubtitle, selection: $viewModel.selectionAge, options: viewModel.agesList)
                            CustomPicker(subtitle: StartChattingViewModel.StartChattingConstants.roleSubtitle, selection: $viewModel.selectionRole, options: viewModel.roleList)
                            CustomPicker(subtitle: StartChattingViewModel.StartChattingConstants.topicTitle, selection: $viewModel.topic, options: viewModel.topicList)
                            
                            if let errorMessage = viewModel.errorMessage{
                                Text(errorMessage)
                                    .foregroundStyle(.red)
                            }
                            CustomButton(title: StartChattingViewModel.StartChattingConstants.find, width: 295, height: 40, backgroundColor: Color.primaryColor, borderColor: Color.primaryColor, textcolor: Color.white, action: {
                                if viewModel.validateSelections(){
                                    viewModel.startChat()
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                        navigateToNextView = true
                                    }
                                    
                                }else{
                                    viewModel.isLoading = false
                                }
                            }, font:   .custom("SFPro-Display-Medium", size: 15))
                        }
                    }
                }
                if viewModel.isLoading{
                    ZStack{
                        Color.gray.opacity(0.2).ignoresSafeArea()
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
                SelectConversationView(showBottomTabBar: $showBottomTabBar)
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
