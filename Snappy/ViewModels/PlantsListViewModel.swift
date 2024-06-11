//
//  PlantsListViewModel.swift
//  Snappy
//
//  Created by Bobby Ren on 6/11/24.
//  Copyright © 2024 RenderApps LLC. All rights reserved.
//

import Foundation
import SwiftUI

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

    @State var sortType: SortType = .nameAZ

    init(store: T) {
        self.store = store
    }

    func photo(for plant: Plant) -> Photo? {
        store.latestPhoto(for: plant)
    }

    var plantsForPhotos: [String: String] {
        var dict = [String: String]()
        store.allPlants.forEach({ plant in
            if let photo = store.latestPhoto(for: plant) {
                dict[photo.id] = plant.id
            }
        })
        return dict
    }

    var allPhotos: [Photo] {
        var photos = [Photo]()
        store.allPlants.forEach({ plant in
            if let photo = store.latestPhoto(for: plant) {
                photos.append(photo)
            }
        })
        return photos
    }

    func sorted() -> [Plant] { //_ plants: [Plant], by sortType: SortType) -> [Plant] {
        var plants = store.allPlants
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
            let plants = plantIDs.compactMap { plantId in
                plants.first { $0.id == plantId }
            }
            return plants
        case .dateNewest:
            let sortedPhotos = allPhotos.sorted { lhs, rhs in
                lhs.timestamp > rhs.timestamp
            }
            let plantIDs = sortedPhotos.compactMap { plantsForPhotos[$0.id] }
            let plants = plantIDs.compactMap { plantId in
                plants.first { $0.id == plantId }
            }
            return plants
        }
    }

}
