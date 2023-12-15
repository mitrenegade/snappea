//
//  DataStore.swift
//  Snappy
//
//  Created by Bobby Ren on 12/14/23.
//  Copyright © 2023 RenderApps LLC. All rights reserved.
//

import Foundation

protocol DataStore {
    func photo(withId id: String) -> Photo?
    func plant(withId id: String) -> Plant?
    func snap(withId id: String) -> Snap?

    /// Cache
    func store(photo: Photo)
    func store(plant: Plant)
    func store(snap: Snap)

    /// Each plant has a collection of snaps
    func snaps(for plant: Plant) -> [Snap]

    /// Each photo has a collection of snaps.
    func snaps(for photo: Photo) -> [Snap]

    /// A photo can have multiple plants. The relationship
    /// is determined by the snaps of that photo
    func plants(for photo: Photo) -> [Plant]

    /// A plant can have multiple photos. The relationship
    /// is determined by the snaps of that plant
    func photos(for plant: Plant) -> [Photo]
}

enum DataStoreError: Error {
    case notAuthorized
    case databaseError(Error?)
}

/// A persistence and caching layer
class FirebaseDataStore: DataStore {
    /// Caching
    private var photoCache: [String: Photo] = [:]
    private var plantCache: [String: Plant] = [:]
    private var snapCache: [String: Snap] = [:]
    private let readWriteQueue: DispatchQueue = DispatchQueue(label: "io.renderapps.APIService.cache")

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
//            if let id = photo.id {
            photoCache[photo.id] = photo
//            }
        }
    }

    public func store(plant: Plant) {
        readWriteQueue.sync {
//            if let id = plant.id {
            plantCache[plant.id] = plant
//            }
        }
    }

    public func store(snap: Snap) {
        readWriteQueue.sync {
//            if let id = snap.id {
            snapCache[snap.id] = snap
//            }
        }
    }
}
