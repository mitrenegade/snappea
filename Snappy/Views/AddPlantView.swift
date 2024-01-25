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

    @Published var imageSelection: PhotosPickerItem? = nil {
        didSet {
            if let imageSelection {
                loadTransferable(from: imageSelection)
            } else {
                // no op
            }
        }
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
                default:
                    return
                }
            }
        }
    }
}

struct AddPlantView: View {

    @State var name: String = ""
    @State var category: Category = .other
    @State var plantType: PlantType = .unknown

    @State var image: Image?

    @ObservedObject var viewModel = AddPlantViewModel()

    private var title: String {
        if TESTING {
            return "AddPlantView"
        } else {
            return "New plant"
        }
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
    }

    private var nameField: some View {
        HStack {
            Spacer()
            TextField(text: $name) {
                Text("Plant name")
            }
            .border(.gray)
            Spacer()
        }
    }

    private var typeField: some View {
            List {
                Picker("Type", selection: $plantType) {
                    ForEach(PlantType.allCases) { plantType in
                        Text(plantType.rawValue.capitalized)
                    }
                }
            }
    }

    private var categoryField: some View {
            List {
                Picker("Category", selection: $category) {
                    ForEach(Category.allCases) { category in
                        Text(category.rawValue.capitalized)
                    }
                }
            }
    }
}
