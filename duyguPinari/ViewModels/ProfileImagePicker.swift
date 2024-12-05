//
//  ProfileImagePicker.swift
//  duyguPinari
//
//  Created by İlknur Tulgar on 4.12.2024.
//

import SwiftUI
import PhotosUI

struct ProfileImagePicker: View {
    @Binding var image: UIImage?
    @State private var isImagePickerPresented = false
    @State private var selectedItem: PhotosPickerItem? // PhotosPickerItem

    var body: some View {
        VStack {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 120)
                    .clipShape(Circle())
            } else {
                Button(action: {
                    isImagePickerPresented.toggle()
                }) {
                    Image(systemName: "camera")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 120, height: 120)
                        .clipShape(Circle())
                        .foregroundColor(.primary)
                }
                .photosPicker(isPresented: $isImagePickerPresented, selection: $selectedItem, matching: .images)
            }
        }
        .onChange(of: selectedItem) { oldItem, newItem in
            Task {
                // Yeni öğe seçildiğinde işlem yap
                guard let selectedItem = newItem else { return }
                if let data = try? await selectedItem.loadTransferable(type: Data.self),
                   let uiImage = UIImage(data: data) {
                    image = uiImage
                }
            }
        }
    }
}


