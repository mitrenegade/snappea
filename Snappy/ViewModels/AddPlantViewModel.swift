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

    @State var isShowingSaveButton: Bool = false

    init(store: T) {
        self.store = store
    }

    func savePlant(image: UIImage?, completion: @escaping (() -> Void)) {
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
            if let image {
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
