//
//  LocalStore.swift
//  Snappy
//
//  Created by Bobby Ren on 1/9/24.
//  Copyright © 2024 RenderApps LLC. All rights reserved.
//

import Foundation

enum StoreError: Error {
    case notAuthorized
    case databaseError(Error?)
}

/// A persistence and caching layer
class LocalStore: Store {
    func loadGarden() async throws {
        for photo in Stub.photoData {
            store(photo: photo)
        }
        for plant in Stub.plantData {
            store(plant: plant)
        }
        for snap in Stub.snapData {
            store(snap: snap)
        }
    }

    /// Caching
    private var photoCache: [String: Photo] = [:]
    private var plantCache: [String: Plant] = [:]
    private var snapCache: [String: Snap] = [:]
    private let readWriteQueue: DispatchQueue = DispatchQueue(label: "io.renderapps.APIService.cache")

    // MARK: -

    var allPhotos: [Photo] { Array(photoCache.values) }
    var allPlants: [Plant] { Array(plantCache.values) }
    var allSnaps: [Snap] { Array(snapCache.values) }

    // MARK: -

    func photo(withId id: String) -> Photo? {
        photoCache[id]
    }

    func plant(withId id: String) -> Plant? {
        plantCache[id]
    }

    func snap(withId id: String) -> Snap? {
        snapCache[id]
    }

    /// Relationships
    func snaps(for photo: Photo) -> [Snap] {
        let snaps = snapCache
            .compactMap { $0.value }
            .filter{ $0.photoId == photo.id }
        return Array(snaps)
    }

    func snaps(for plant: Plant) -> [Snap] {
        let snaps = snapCache
            .compactMap { $0.value }
            .filter{ $0.plantId == plant.id }
        return Array(snaps)
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

    // MARK: - Cache
    public func store(photo: Photo) {
        readWriteQueue.sync {
            photoCache[photo.id] = photo
        }
    }

    public func store(plant: Plant) {
        readWriteQueue.sync {
            plantCache[plant.id] = plant
        }
    }

    public func store(snap: Snap) {
        readWriteQueue.sync {
            snapCache[snap.id] = snap
        }
    }
}

/// Temporary
class FirebaseStore: LocalStore {
    // no op
}
