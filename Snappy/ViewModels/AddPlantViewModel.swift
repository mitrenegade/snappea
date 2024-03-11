//
//  AddPlantViewModel.swift
//  Snappy
//
//  Created by Bobby Ren on 3/9/24.
//  Copyright © 2024 RenderApps LLC. All rights reserved.
//

import SwiftUI
import PhotosUI

class AddPlantViewModel<T>: ObservableObject where T: Store {

    @Published var image: Image? = nil
    @Published var uiImage: UIImage? = nil
    @Published var name: String = ""
    @Published var category: Category = .other
    @Published var plantType: PlantType = .unknown

    var errorMessage: String? {
        didSet {
            isShowingError = errorMessage == nil
        }
    }

    @Published var isShowingError: Bool = false

    @Published var store: T

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

    init(store: T) {
        self.store = store
    }

    private func loadTransferable(from imageSelection: PhotosPickerItem) {
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

    func savePlant(completion: @escaping (() -> Void)) {
        if TESTING {
            if name.isEmpty {
                name = "abc"
            }
            if category == .other {
                category = .brassica
            }
            if plantType == .unknown {
                plantType = .lettuce
            }
        } else {
            guard !name.isEmpty,
                  category != .other,
                  plantType != .unknown else {
                errorMessage = "Invalid information for plant. Please enter all fields."
                return
            }
        }

        print("Saving plant \(name) of category \(category) and type \(plantType)")

        Task {
            let plant = try await store.createPlant(name: name, type: plantType, category: category)

            // Save photo and associated it with the plant
            // by creating a snap
            if let image = self.uiImage {
                let _ = await saveImage(image: image, plant: plant)
            }
            completion()
        }

    }

    func saveImage(image: UIImage, plant: Plant) async -> (Photo, Snap)? {
        do {
            let photo = try await store.createPhoto(image: image)
            let snap = try await store.createSnap(plant: plant, photo: photo, start: NormalizedCoordinate.start, end: NormalizedCoordinate.end)
            return (photo, snap)
        } catch {
            print("Save photo error \(error)")
            return nil
        }
    }

}
