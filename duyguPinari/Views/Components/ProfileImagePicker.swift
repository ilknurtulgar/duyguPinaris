//
//  ProfileImagePicker.swift
//  duyguPinari
//
//  Created by İlknur Tulgar on 4.12.2024.
//

import SwiftUI
import PhotosUI

struct ProfileImagePicker: View {
    @Binding var imagePath: String? 
    @State private var isImagePickerPresented = false
    @State private var selectedItem: PhotosPickerItem?

    var body: some View {
        VStack {
            if let imagePath = imagePath {
                if let url = URL(string: imagePath), url.scheme == "http" || url.scheme == "https" {
                    // URL üzerinden görsel yükle
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: Color.primaryColor))
                                .scaleEffect(1.5)
                                .padding(10)
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFit()
                                .frame(width: 120, height: 120)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(Color.gray, lineWidth: 1))
                        case .failure:
                            defaultImage
                        @unknown default:
                            EmptyView()
                        }
                    }
                } else if let uiImage = UIImage(contentsOfFile: imagePath) {
                    // Yerel dosya yolundan görsel yükle
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 120, height: 120)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.gray, lineWidth: 1))
                } else {
                    defaultImage
                }
            } else {
                defaultImage
            }

            Button(action: {
                isImagePickerPresented.toggle()
            }) {
                TextStyles.subtitleRegular("Profil Resmi Seç")
                    .foregroundColor(Color.textColor)
            }
            .photosPicker(isPresented: $isImagePickerPresented, selection: $selectedItem, matching: .images)
        }
        .onChange(of: selectedItem) { oldItem, newItem in
            Task {
                guard let selectedItem = newItem else { return }
                if let data = try? await selectedItem.loadTransferable(type: Data.self) {
                    // Yeni görsel için geçici bir yol oluştur
                    let tempDirectory = FileManager.default.temporaryDirectory
                    let tempPath = tempDirectory.appendingPathComponent(UUID().uuidString).path
                    FileManager.default.createFile(atPath: tempPath, contents: data)
                    imagePath = tempPath // Yeni dosya yolu atanır
                }
            }
        }
    }

    private var defaultImage: some View {
        Image(systemName: "person.crop.circle")
            .resizable()
            .scaledToFit()
            .frame(width: 120, height: 120)
            .clipShape(Circle())
            .overlay(Circle().stroke(Color.gray, lineWidth: 1))
            .foregroundColor(.gray)
    }
}



