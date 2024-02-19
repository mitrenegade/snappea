//
//  MockStore.swift
//  Snappy
//
//  Created by Bobby Ren on 12/14/23.
//  Copyright © 2023 RenderApps LLC. All rights reserved.
//

import Foundation
import UIKit

class MockStore: Store {
    var isLoading: Bool = false

    func loadGarden(id: String) async throws {
        // no op
    }

    var allPhotos: [Photo] {
        Stub.photoData
    }

    @Published var allPlants: [Plant] = Stub.plantData
    var allPlantsValue: Published<[Plant]> {
        return _allPlants
    }
    var allPlantsPublisher: Published<[Plant]>.Publisher {
        return $allPlants
    }

    var allSnaps: [Snap] {
        Stub.snapData
    }

    // MARK: - Fetch

    func photo(withId id: String) -> Photo? {
        allPhotos.first { $0.id == id }
    }

    func plant(withId id: String) -> Plant? {
        allPlants.first { $0.id == id }
    }

    func snap(withId id: String) -> Snap? {
        allSnaps.first { $0.id == id }
    }

    /// Relationships
    func snaps(for photo: Photo) -> [Snap] {
        allSnaps.filter{ $0.photoId == photo.id }
    }

    func snaps(for plant: Plant) -> [Snap] {
        allSnaps.filter{ $0.plantId == plant.id }
    }

    func plants(for photo: Photo) -> [Plant] {
        let snaps = snaps(for: photo)
        let plants = snaps.compactMap { plant(withId: $0.plantId) }
        return Array(Set(plants))
    }

    func photos(for plant: Plant) -> [Photo] {
        let snaps = snaps(for: plant)
        let photos = snaps.compactMap { photo(withId:$0.photoId) }
        return Array(Set(photos))
    }

    // MARK: -

    func createPlant(name: String, type: PlantType, category: Category) throws -> Plant {
        // no op
        fatalError()
    }

    func createPhoto(image: UIImage) throws -> Photo {
        // no op
        fatalError()
    }

    func createSnap(photo: Photo, start: NormalizedCoordinate, end: NormalizedCoordinate) async throws -> Snap {
        // no op
        fatalError()
    }
}
