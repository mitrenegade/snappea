//
//  AddPlantView.swift
//  Snappy
//
//  Created by Bobby Ren on 12/28/23.
//  Copyright © 2023 RenderApps LLC. All rights reserved.
//

import SwiftUI
import PhotosUI

class AddPlantViewModel: ObservableObject {

    @Published var image: Image? = nil
    @Published var name: String = ""
    @Published var category: Category = .other
    @Published var plantType: PlantType = .unknown

    var errorMessage: String? {
        didSet {
            isShowingError = errorMessage == nil
        }
    }

    @Published var isShowingError: Bool = false

    private let store: Store

    @Published var imageSelection: PhotosPickerItem? = nil {
        didSet {
            if let imageSelection {
                loadTransferable(from: imageSelection)
            } else {
                // no op
            }
        }
    }

    @State var isShowingSaveButton: Bool = false

    init(store: Store) {
        self.store = store
    }

    private func loadTransferable(from imageSelection: PhotosPickerItem) {
        imageSelection.loadTransferable(type: Image.self) { result in
            DispatchQueue.main.async {
                guard imageSelection == self.imageSelection else {
                    print("Failed to get the selected item.")
                    return
                }
                switch result {
                case .success(let image):
                    self.image = image
                    self.isShowingSaveButton = true
                default:
                    self.isShowingSaveButton = false
                    return
                }
            }
        }
    }

    func savePlant(completion: @escaping (() -> Void)) {
        guard !name.isEmpty,
              category != .other,
              plantType != .unknown else {
            errorMessage = "Invalid information for plant. Please enter all fields."
            return
        }

        print("Saving plant \(name) of category \(category) and type \(plantType)")

        Task {
            let plant = try await store.createPlant(name: name, type: plantType, category: category)

            // TODO: save photo
            completion()
        }

    }
}

struct AddPlantView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    @State var image: Image?

    @ObservedObject var viewModel: AddPlantViewModel

    private var title: String {
        if TESTING {
            return "AddPlantView"
        } else {
            return "New plant"
        }
    }

    init(store: Store) {
        self.viewModel = AddPlantViewModel(store: store)
    }

    var body: some View {
        Text(title)
        VStack {
            if let image = viewModel.image {
                image
                    .resizable()
                    .frame(width: UIScreen.main.bounds.width,
                            height: UIScreen.main.bounds.width)
                    .aspectRatio(contentMode: .fit)
                    .clipped()
            } else {
                PhotosPicker(selection: $viewModel.imageSelection,
                             matching: .images,
                             photoLibrary: .shared()) {
                    Image(systemName: "camera")
                        .frame(width: 100, height: 100)
                        .aspectRatio(contentMode: .fill)
                        .foregroundColor(Color.black)
                        .background(Color.green)
                        .clipShape(Circle())
                }.buttonStyle(.borderless)
            }

            nameField
            categoryField
            typeField
        }
        .navigationBarItems(trailing: saveButton)
        .alert(isPresented: $viewModel.isShowingError) {
            Alert(title: Text(viewModel.errorMessage ?? "Unknown error"))
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

    private var saveButton: some View {
        Button(action: {
            viewModel.savePlant() {
                DispatchQueue.main.async {
                    self.presentationMode.wrappedValue.dismiss()
                }
            }
        }) {
            Text("Save")
        }
    }
}
