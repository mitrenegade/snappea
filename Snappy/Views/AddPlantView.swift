//
//  AddPlantView.swift
//  Snappy
//
//  Created by Bobby Ren on 12/28/23.
//  Copyright © 2023 RenderApps LLC. All rights reserved.
//

import SwiftUI
import PhotosUI

struct AddPlantView<T>: View where T: Store {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var photoEnvironment: PhotoEnvironment
    @EnvironmentObject var imageLoaderFactory: ImageLoaderFactory

    @ObservedObject var viewModel: AddPlantViewModel<T>

    /// Image picker layer
    @State private var showingAddImageLayer = false
    @State var image: UIImage? = nil

    @State var isSaveButtonEnabled: Bool = false

    @Binding var shouldShowGallery: Bool

    private var title: String {
        if TESTING {
            return "AddPlantView"
        } else {
            return "New plant"
        }
    }

    var body: some View {
        ZStack {
            VStack {
                Text(title)
                if let image {
                    Image(uiImage: image)
                        .resizable()
                        .frame(width: UIScreen.main.bounds.width,
                               height: UIScreen.main.bounds.width)
                        .aspectRatio(contentMode: .fit)
                        .clipped()
                } else if let newPhoto = photoEnvironment.newPhoto {
                    let imageLoader = imageLoaderFactory.create(imageName: newPhoto.id, cache: TemporaryImageCache.shared)
                    let placeholder = Text("Loading...")
                    let imageSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width)
                    AsyncImageView(imageLoader: imageLoader, frame: imageSize, placeholder: placeholder)
                        .aspectRatio(contentMode: .fill)
                }
                captureImageButton

                nameField
                categoryField
                typeField
            }
            .navigationBarItems(trailing: saveButton)
            .alert(isPresented: $viewModel.isShowingError) {
                Alert(title: Text(viewModel.errorMessage ?? "Unknown error"))
            }

            if showingAddImageLayer {
                AddImageHelperLayer(image: $image, showingSelf: $showingAddImageLayer, canShowGallery: true, shouldShowGallery: $shouldShowGallery)
            }
        }
        .onChange(of: image) {
            // image selected
            if image != nil {
                showingAddImageLayer = false
                isSaveButtonEnabled = true
                photoEnvironment.newPhoto = nil
            }
        }
        .onChange(of: photoEnvironment.isAddingPhotoToPlant) {
            // photo selected
            if photoEnvironment.isAddingPhotoToPlant,
               let _ = photoEnvironment.newPhoto {
                isSaveButtonEnabled = true
                image = nil
            }
        }
        .onDisappear {
            photoEnvironment.reset()
        }
    }

    private var nameField: some View {
        HStack {
            Spacer()
            TextField(text: $viewModel.name) {
                Text("Plant name")
            }
            .border(.gray)
            Spacer()
        }
    }

    private var typeField: some View {
        List {
            Picker("Type", selection: $viewModel.plantType) {
                ForEach(PlantType.allCases) { plantType in
                    Text(plantType.rawValue.capitalized)
                }
            }
        }
    }

    private var categoryField: some View {
        List {
            Picker("Category", selection: $viewModel.category) {
                ForEach(Category.allCases) { category in
                    Text(category.rawValue.capitalized)
                }
            }
        }
    }

    var captureImageButton: some View {
        Button(action: {
            print("BRDEBUG AddPlantView: add image")
            self.showingAddImageLayer = true
        }) {
            if image == nil {
                Text("Add photo")
            } else {
                Text("Change photo")
            }
        }
    }

    private var saveButton: some View {
        Button(action: {
            guard image != nil || photoEnvironment.newPhoto != nil else {
                return
            }
            viewModel.savePlant(image: image, photo: photoEnvironment.newPhoto) { result in
                if case(let error) = result {
                    // TODO: add error message
                    print("Create plant error \(error)")
                }
                DispatchQueue.main.async {
                    self.presentationMode.wrappedValue.dismiss()
                }
                self.image = nil
            }
        }) {
            Text("Save")
        }
        .disabled(!isSaveButtonEnabled)
    }
}
