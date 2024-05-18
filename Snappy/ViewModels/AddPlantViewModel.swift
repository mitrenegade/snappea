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

    func savePlant(image: UIImage?, photo: Photo?, completion: @escaping ((Result<Plant, Error>) -> Void)) {
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
                do {
                    let _ = try await saveNewImage(image, for: plant)
                    completion(.success(plant))
                } catch let error {
                    print("Save photo error \(error)")
                    completion(.failure(error))
                }
            } else if let photo {
                do {
                    let _ = try await savePhoto(photo, for: plant)
                    completion(.success(plant))
                } catch let error {
                    print("Save photo error \(error)")
                    completion(.failure(error))
                }
            } else {
                completion(.success(plant))
            }
        }

    }

    private func saveNewImage(_ image: UIImage, for plant: Plant) async throws -> (Photo, Snap)? {
        let photo = try await store.createPhoto(image: image)
        return try await savePhoto(photo, for: plant)
    }

    private func savePhoto(_ photo: Photo, for plant: Plant) async throws -> (Photo, Snap)? {
        let snap = try await store.createSnap(plant: plant, photo: photo, start: NormalizedCoordinate.start, end: NormalizedCoordinate.end)
        return (photo, snap)
    }
}
