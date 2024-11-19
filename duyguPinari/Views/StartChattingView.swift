//
//  StartChattingView.swift
//  duyguPinari
//
//  Created by İlknur Tulgar on 19.11.2024.
//

import SwiftUI

struct StartChattingView: View {
    @State var isComplete: Bool = false
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = StartChattingViewModel()
    var body: some View {
        NavigationStack{
            ZStack{
                Color.backgroundPrimary.ignoresSafeArea()
                VStack(spacing:0){
                    CustomToolBar(title: StartChattingViewModel.StartChattingConstants.startConversation, icon:Image(systemName: "chevron.left"), action: {dismiss()})
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
                                    isComplete = true
                                }else
                                {
                                    isComplete = false
                                }
                            }, font:   .custom("SFPro-Display-Medium", size: 15))
                            .navigationDestination(isPresented: $isComplete){
                                LoadingChatView()
                                    .navigationBarHidden(true)
                            }
                        }
                    }
                }
                
            }
            
        }
    }
}

/*#Preview {
    StartChattingView()
}*/
