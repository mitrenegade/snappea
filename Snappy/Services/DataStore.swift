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
    func fetchSnaps() async throws -> [Tag]
}

enum DataStoreError: Error {
    case notAuthorized
    case databaseError(Error?)
}

class FirebaseDataStore: DataStore {
    private let db = Firestore.firestore()
    private let auth: AuthStore

    private var userId: String? {
        auth.user?.id
    }

    init(authStore: AuthStore = AuthStore.shared) {
        self.auth = authStore
    }

    func fetchPhotos() async throws -> [Photo] {
        try await fetchObjects(collection: "photos")
    }

    func fetchPlants() async throws -> [Plant] {
        try await fetchObjects(collection: "plants")
    }

    func fetchSnaps() async throws -> [Tag] {
        try await fetchObjects(collection: "snaps")
    }

    /// Generic to fetch an object given a collection name
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
}
