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
class PlantsListViewModel: ObservableObject{
    enum SortType {
        case nameAZ
        case nameZA
        case categoryAZ
        case categoryZA
        case dateOldest
        case dateNewest
    }

    @Published var sortType: SortType = .nameAZ
    @Published var sorted: [Plant] = []

    /// Creates a structure to hold all the current photos for each plant
    private var allPhotos = [Photo]()

    /// Creates a structure to relate photo IDs -> plants
    private var plantsForPhotos = [String: Plant]()

    /// Creates a structure to relate plant IDs -> photos
    private var photosForPlant = [String: Photo]()

    private var cancellables = Set<AnyCancellable>()

    private let allPlants: [Plant]

    init(store: any Store) {
        allPlants = store.allPlants

        $sortType
            .map { self.sort(sortType: $0) }
            .assign(to: \.sorted, on: self)
            .store(in: &cancellables)

        // generate allPhotos and plantsForPhotos
        store.allPlants.forEach({ plant in
            if let photo = store.latestPhoto(for: plant) {
                allPhotos.append(photo)
                plantsForPhotos[photo.id] = plant
                photosForPlant[plant.id] = photo
            }
        })
    }

    /// Returns the latest photo given a plant
    func photo(for plant: Plant) -> Photo? {
        photosForPlant[plant.id]
    }

    /// Returns the array of plants given a sort type
    private func sort(sortType: SortType) -> [Plant] {
        let plants = allPlants
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
            return sortedPhotos.compactMap { plantsForPhotos[$0.id] }
        case .dateNewest:
            let sortedPhotos = allPhotos.sorted { lhs, rhs in
                lhs.timestamp > rhs.timestamp
            }
            return sortedPhotos.compactMap { plantsForPhotos[$0.id] }
        }
    }

}
