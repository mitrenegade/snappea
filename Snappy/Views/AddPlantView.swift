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

    @ObservedObject var viewModel: AddPlantViewModel<T>

    /// Image picker layer
    @State private var showingAddImageLayer = false
    @State var image: UIImage? = nil
    @State var imageSelected: Bool = false // if true, then override showingAddImageLayer

    @State var isSaveButtonEnabled: Bool = false

    private var title: String {
        if TESTING {
            return "AddPlantView"
        } else {
            return "New plant"
        }
    }

    init(store: T) {
        self.viewModel = AddPlantViewModel(store: store)
    }

    var body: some View {
        Text(title)
        ZStack {
            VStack {
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

            if showingAddImageLayer && !imageSelected {
                AddImageHelperLayer(image: $image, imageSelected: $imageSelected)
            }
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
            }
        }
    }

    var captureImageButton: some View {
        Button(action: {
            self.showingAddImageLayer.toggle()
            self.imageSelected = false
        }) {
            if image == nil {
                Text("Add photo")
            } else {
                // BR TODO this requires two clicks to display layer
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
