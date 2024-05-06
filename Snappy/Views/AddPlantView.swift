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
                imagePreview
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
            showingAddImageLayer = false
            isSaveButtonEnabled = image != nil
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

    var imagePreview: some View {
        Group {
            if let image {
                Image(uiImage: image)
                    .resizable()
                    .frame(width: UIScreen.main.bounds.width,
                           height: UIScreen.main.bounds.width)
                    .aspectRatio(contentMode: .fit)
                    .clipped()
            } else if let photo = photoEnvironment.newPhoto {
                // BR TODO display image for selected Photo
            }
        }
    }

    var captureImageButton: some View {
        Button(action: {
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
            viewModel.savePlant(image: image) {
                DispatchQueue.main.async {
                    self.presentationMode.wrappedValue.dismiss()
                }
            }
        }) {
            Text("Save")
        }
        .disabled(!isSaveButtonEnabled)
    }
}
