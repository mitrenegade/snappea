//
//  PlantsListViewModel.swift
//  Snappy
//
//  Created by Bobby Ren on 6/11/24.
//  Copyright © 2024 RenderApps LLC. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

/// Handles sorting and filtering
class PlantsListViewModel<T: Store>: ObservableObject{
    enum SortType {
        case nameAZ
        case nameZA
        case categoryAZ
        case categoryZA
        case dateOldest
        case dateNewest
    }

    let store: T

    @Published var sortType: SortType = .nameAZ
    @Published var sorted: [Plant] = []

    private var cancellables = Set<AnyCancellable>()

    init(store: T) {
        self.store = store
        $sortType
            .map { self.sort(sortType: $0) }
            .assign(to: \.sorted, on: self)
            .store(in: &cancellables)
    }

    /// Returns the latest photo given a plant
    func photo(for plant: Plant) -> Photo? {
        store.latestPhoto(for: plant)
    }

    /// Creates a structure to relate photo IDs -> plant IDs
    private var plantsForPhotos: [String: String] {
        var dict = [String: String]()
        store.allPlants.forEach({ plant in
            if let photo = store.latestPhoto(for: plant) {
                dict[photo.id] = plant.id
            }
        })
        return dict
    }

    /// Creates a structure to hold all the current photos for each plant
    private var allPhotos: [Photo] {
        var photos = [Photo]()
        store.allPlants.forEach({ plant in
            if let photo = store.latestPhoto(for: plant) {
                photos.append(photo)
            }
        })
        return photos
    }

    /// Returns the array of plants given a sort type
    private func sort(sortType: SortType) -> [Plant] {
        let plants = store.allPlants
        switch sortType {
        case .nameAZ:
            return plants.sorted { $0.name < $1.name }
        case .nameZA:
            return plants.sorted { $0.name > $1.name }
        case .categoryAZ:
            return plants.sorted { $0.category < $1.category }
        case .categoryZA:
            return plants.sorted { $0.category > $1.category }
        case .dateOldest:
            let sortedPhotos = allPhotos.sorted { lhs, rhs in
                lhs.timestamp < rhs.timestamp
            }
            let plantIDs = sortedPhotos.compactMap { plantsForPhotos[$0.id] }
            return plantIDs.compactMap { plantId in
                plants.first { $0.id == plantId }
            }
        case .dateNewest:
            let sortedPhotos = allPhotos.sorted { lhs, rhs in
                lhs.timestamp > rhs.timestamp
            }
            let plantIDs = sortedPhotos.compactMap { plantsForPhotos[$0.id] }
            return plantIDs.compactMap { plantId in
                plants.first { $0.id == plantId }
            }
        }
    }

}
