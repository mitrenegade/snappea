//
//  FirebaseStore.swift
//  Snappy
//
//  Created by Bobby Ren on 1/14/24.
//  Copyright © 2024 RenderApps LLC. All rights reserved.
//

import Foundation
import UIKit
import FirebaseFirestore

/// An implementation of Store that uses Firebase's API, via FirebaseAPIService
class FirebaseStore: Store {

    /// Auth
    private let auth: AuthStore

    /// Firebase Database
    let db = Firestore.firestore()

    // MARK: - Initialization
    init(authStore: AuthStore = AuthStore.shared) {
        self.auth = authStore
    }

    func loadGarden() async throws {
        let group = DispatchGroup()
        Task {
            group.enter()
            allPhotos = try await fetchPhotos()
        }
        Task {
            group.enter()
            allPlants = try await fetchPlants()
        }
        Task {
            group.enter()
            allSnaps = try await fetchSnaps()
        }
        group.notify(queue: DispatchQueue.global()) {
            print("Load garden complete with \(self.allPhotos.count) photos, \(self.allPlants.count) plants, \(self.allSnaps.count) snaps")
        }
    }

    var allPhotos: [Photo] = []

    var allPlants: [Plant] = []

    var allSnaps: [Snap] = []

    func photo(withId id: String) -> Photo? {
        nil
    }

    func plant(withId id: String) -> Plant? {
        nil
    }

    func snap(withId id: String) -> Snap? {
        nil
    }

    func snaps(for plant: Plant) -> [Snap] {
        []
    }

    func snaps(for photo: Photo) -> [Snap] {
        []
    }

    func plants(for photo: Photo) -> [Plant] {
        []
    }

    func photos(for plant: Plant) -> [Photo] {
        []
    }

    // MARK: -
    func createPhoto(image: UIImage) async throws -> Photo {
        let timestamp = Date().timeIntervalSince1970
        var result = try await addPhoto(timestamp: timestamp)

        // BR TODO: contain uploadImage into uploadURL
        FirebaseImageService.uploadImage(image: image, type: .photo, uid: result.id) { [weak self] url in
            if let url {
                do {
                    try self?.updatePhotoUrl(result, url: url) { error in
                        result.url = url // manually update url in existing photo object locally
                    }
                } catch {
                    print("Update photo \(error)")
                }
            }
        }
        return result
    }

    func createPlant(name: String, type: PlantType, category: Category) async throws -> Plant {
        let plant = try await addPlant(name: name, type: type, category: category)
        return plant
    }

    func createSnap(photo: Photo, start: NormalizedCoordinate, end: NormalizedCoordinate) async throws -> Snap {
        let snap = try await addSnap(photoId: photo.id, start: start, end: end)
        return snap
    }
}

/// Direct calls to API
extension FirebaseStore {
    private var userId: String? {
        auth.user?.id
    }

    // MARK: - Fetch
    private func fetchPhotos() async throws -> [Photo] {
        try await fetchObjects(collection: "photos")
    }

    private func fetchPlants() async throws -> [Plant] {
        try await fetchObjects(collection: "plants")
    }

    private func fetchSnaps() async throws -> [Snap] {
        try await fetchObjects(collection: "snaps")
    }

    // MARK: - Upload async/await

    /// Creates a Photo object in firebase
    /// Note: image upload and url update are done separately
    private func addPhoto(timestamp: Double) async throws -> Photo {
        return try await add(collection: "photos", data: ["timestamp": timestamp])
    }

    private func addPlant(name: String, type: PlantType, category: Category) async throws -> Plant {
        let data: [String: Any] = ["namne": name, "type": type.rawValue, "category": category.rawValue]
        return try await add(collection: "plants", data: data)
    }

    private func addSnap(photoId: String, start: NormalizedCoordinate, end: NormalizedCoordinate) async throws -> Snap {
        let data: [String: Any] = ["photoId": photoId,
                                   "start": start,
                                   "end": end]
        return try await add(collection: "snaps", data: data)
    }

    // MARK: - Generic interface into Firebase
    /// Fetches an array of an object type given a collection name
    private func fetchObjects<T: Decodable>(collection: String) async throws -> [T] {
        guard let userId = userId else {
            throw StoreError.notAuthorized
        }
        let snapshot = try await db.collection(userId).document("garden").collection(collection).getDocuments()

        let objects = snapshot.documents.compactMap { document -> T? in
            try? document.data(as: T.self)
        }
        return objects
    }

    // upload to db and save locally
    private func add<T: Codable>(collection: String, data: [String: Any]) async throws -> T {
        guard let userId = userId else {
            throw StoreError.notAuthorized
        }
        let ref = try await db.collection(userId)
            .document("garden").collection(collection)
            .addDocument(data: data)

        let snapshot = try await ref.getDocument()
        let result = try snapshot.data(as: T.self)
        return result
    }

    private func updatePhotoUrl(_ photo: Photo, url: String, completion: ((Error?)->Void)? = nil) throws {
        guard let userId = userId else {
            throw StoreError.notAuthorized
        }
        let ref = db.collection(userId).document("garden").collection("photos").document(photo.id)
        ref.updateData(["url":url], completion: completion)
    }

}
