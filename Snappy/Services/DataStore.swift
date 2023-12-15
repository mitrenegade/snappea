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

    func snaps(for plant: Plant) -> [Snap]
    func photo(for snap: Snap) -> Photo?
}

enum DataStoreError: Error {
    case notAuthorized
    case databaseError(Error?)
}

class FirebaseDataStore: DataStore {
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

    func snaps(for plant: Plant) -> [Snap] {
        let snaps = snapCache
            .filter{ $0.value.plantId == plant.id }
            .values
        return Array(snaps)
    }

    func photo(for snap: Snap) -> Photo? {
        photoCache
            .first(where: { $0.value.id == snap.photoId })?
            .value
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
            if let id = photo.id {
                photoCache[id] = photo
            }
        }
    }

    private func store(plant: Plant) {
        readWriteQueue.sync {
            if let id = plant.id {
                plantCache[id] = plant
            }
        }
    }

    private func store(snap: Snap) {
        readWriteQueue.sync {
            if let id = snap.id {
                snapCache[id] = snap
            }
        }
    }
}
