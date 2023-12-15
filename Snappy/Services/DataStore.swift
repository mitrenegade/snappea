//
//  DataStore.swift
//  Snappy
//
//  Created by Bobby Ren on 12/14/23.
//  Copyright © 2023 RenderApps LLC. All rights reserved.
//

import Foundation
import Firebase

protocol DataStore {
    func fetchPhotos() async throws -> [Photo]
    func fetchPlants() async throws -> [Plant]
    func fetchSnaps() async throws -> [Snap]

    func photo(withId id: String) -> Photo?
    func plant(withId id: String) -> Plant?
    func snap(withId id: String) -> Snap?

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

class FirebaseDataStore: DataStore {
    // TODO: FirebaseDataStore should actually be FirebaseAPIService
    // DataStore should just be a temporary cache or a persistence layer

    /// Firebase
    private let db = Firestore.firestore()

    /// Auth
    private let auth: AuthStore
    private var userId: String? {
        auth.user?.id
    }

    /// Caching
    private var photoCache: [String: Photo] = [:]
    private var plantCache: [String: Plant] = [:]
    private var snapCache: [String: Snap] = [:]
    private let readWriteQueue: DispatchQueue = DispatchQueue(label: "io.renderapps.APIService.cache")

    // MARK: - Initialization
    init(authStore: AuthStore = AuthStore.shared) {
        self.auth = authStore
    }

    // MARK: - DataStore Interface
    func fetchPhotos() async throws -> [Photo] {
        let photos: [Photo] = try await fetchObjects(collection: "photos")
        for photo in photos {
            store(photo: photo)
        }
        return photos
    }

    func fetchPlants() async throws -> [Plant] {
        let plants: [Plant] = try await fetchObjects(collection: "plants")
        for plant in plants {
            store(plant: plant)
        }
        return plants
    }

    func fetchSnaps() async throws -> [Snap] {
        let snaps: [Snap] = try await fetchObjects(collection: "snaps")
        for snap in snaps {
            store(snap: snap)
        }
        return snaps
    }

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

    // MARK: - Generic interface into Firebase
    /// Fetches an array of an object type given a collection name
    private func fetchObjects<T: Decodable>(collection: String) async throws -> [T] {
        guard let userId = userId else {
            throw DataStoreError.notAuthorized
        }
        return try await withCheckedThrowingContinuation { continuation in
            db.collection(userId).document("garden").collection(collection).addSnapshotListener { (snapshot, error) in
                guard let snapshot else {
                    continuation.resume(throwing: DataStoreError.databaseError(error))
                    return
                }
                let objects = snapshot.documents.compactMap { document -> T? in
                    try? document.data(as: T.self)
                }
                continuation.resume(returning: objects)
            }
        }
    }

    // MARK: - Cache
    private func store(photo: Photo) {
        readWriteQueue.sync {
//            if let id = photo.id {
            photoCache[photo.id] = photo
//            }
        }
    }

    private func store(plant: Plant) {
        readWriteQueue.sync {
//            if let id = plant.id {
            plantCache[plant.id] = plant
//            }
        }
    }

    private func store(snap: Snap) {
        readWriteQueue.sync {
//            if let id = snap.id {
            snapCache[snap.id] = snap
//            }
        }
    }
}
