//
//  AddPhotoView.swift
//  Snappy
//
//  Created by Bobby Ren on 3/9/24.
//  Copyright © 2024 RenderApps LLC. All rights reserved.
//

import SwiftUI
import PhotosUI

struct AddPhotoToPlantView<T>: View where T: Store {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    @State var image: Image?

    @State var uiImage: UIImage? = nil

    @ObservedObject var store: T

    private let plant: Plant

//    @ObservedObject var viewModel: AddPlantViewModel<T>
    @State var imageSelection: PhotosPickerItem?

    @State var isShowingSaveButton: Bool = false

    private var title: String {
        if TESTING {
            return "AddPhotoToPlantView"
        } else {
            return "Add Photo"
        }
    }

    init(store: T, plant: Plant) {
        self.store = store
        self.plant = plant
    }

    var body: some View {
        Text(title)
        VStack {
            if let image {
                image
                    .resizable()
                    .frame(width: UIScreen.main.bounds.width,
                            height: UIScreen.main.bounds.width)
                    .aspectRatio(contentMode: .fit)
                    .clipped()
            } else {
                PhotosPicker(selection: $imageSelection,
                             matching: .images,
                             photoLibrary: .shared()) {
                    Image(systemName: "camera")
                        .frame(width: 100, height: 100)
                        .aspectRatio(contentMode: .fill)
                        .foregroundColor(Color.black)
                        .background(Color.green)
                        .clipShape(Circle())
                }
                             .buttonStyle(.borderless)
                                .onChange(of: imageSelection) { oldValue, newValue in
                                 Task {
                                     if let data = try? await imageSelection?.loadTransferable(type: Data.self),
                                     let loadedImage = UIImage(data: data) {
                                         uiImage = loadedImage
                                         image = Image(uiImage: loadedImage)
                                     }
                                 }
                             }
            }
        }
        .navigationBarItems(trailing: saveButton)
//        .alert(isPresented: $viewModel.isShowingError) {
//            Alert(title: Text(viewModel.errorMessage ?? "Unknown error"))
//        }

    }

    private var saveButton: some View {
        Button(action: {
//            savePhoto()
            // TODO: Save photo to plant
                DispatchQueue.main.async {
                    self.presentationMode.wrappedValue.dismiss()
                }
//            }
        }) {
            Text("Save")
        }
    }
}

// TODO: move this to a common photo class
extension AddPhotoToPlantView {
    fileprivate func loadTransferable(from imageSelection: PhotosPickerItem) {
        imageSelection.loadTransferable(type: Data.self) { result in
            DispatchQueue.main.async {
                guard imageSelection == self.imageSelection else {
                    print("Failed to get the selected item.")
                    return
                }
                switch result {
                case .success(let data):
                    if let data = data,
                       let uiImage = UIImage(data: data) {
                        self.image = Image(uiImage: uiImage)
                        self.uiImage = uiImage
                        self.isShowingSaveButton = true
                    }
                default:
                    self.isShowingSaveButton = false
                    return
                }
            }
        }
    }

}
