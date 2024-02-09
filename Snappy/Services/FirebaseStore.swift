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
        let id = UUID().uuidString // TODO use firebase id
        let timestamp = Date().timeIntervalSince1970
        let photo = Photo(id: id, timestamp: timestamp)
        var result = try await addPhoto(photo)

        // BR TODO: contain uploadImage into uploadURL
        FirebaseImageService.uploadImage(image: image, type: .photo, uid: photo.id) { [weak self] url in
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
        let id = UUID().uuidString // TODO use firebase id
        let plant = Plant(id: id, name: name, type: type, category: category)
        let result = try await addPlant(plant)
        return result
    }

    func createSnap(photo: Photo, start: CGPoint, end: CGPoint, imageSize: CGSize) async throws -> Snap {
        let id = UUID().uuidString // TODO use firebase id
        let snap = Snap(photoId: photo.id,
                        start: NormalizedCoordinate(x: start.x, y: start.y),
                        end: NormalizedCoordinate(x: end.x, y: start.y))
        let result = try await addSnap(snap)
        return result
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
    private func addPhoto(_ photo: Photo) async throws -> Photo {
        try await add(photo, collection: "photos")
    }

    private func addPlant(_ plant: Plant) async throws -> Plant {
        try await add(plant, collection: "plants")
    }

    private func addSnap(_ snap: Snap) async throws -> Snap {
        try await add(snap, collection: "snaps")
    }

    // MARK: - Generic interface into Firebase
    /// Fetches an array of an object type given a collection name
    private func fetchObjects<T: Decodable>(collection: String) async throws -> [T] {
        guard let userId = userId else {
            throw StoreError.notAuthorized
        }
        return try await withCheckedThrowingContinuation { continuation in
            db.collection(userId).document("garden").collection(collection).addSnapshotListener { (snapshot, error) in
                guard let snapshot else {
                    continuation.resume(throwing: StoreError.databaseError(error))
                    return
                }
                let objects = snapshot.documents.compactMap { document -> T? in
                    try? document.data(as: T.self)
                }
                continuation.resume(returning: objects)
            }
        }
    }

    // upload to db and save locally
    private func add<T: Codable>(_ object: T, collection: String) async throws -> T {
        return try await withCheckedThrowingContinuation { continuation in
            guard let userId = self.userId else {
                continuation.resume(throwing: StoreError.notAuthorized)
                return
            }

            do {
                let ref = try db.collection(userId)
                    .document("garden").collection(collection)
                    .addDocument(from: object)
                ref.getDocument { (snapshot, error) in
                    if let result = try? snapshot?.data(as: T.self) {
                        continuation.resume(with: .success(result))
                    } else {
                        continuation.resume(with: .failure(StoreError.databaseError(error)))
                    }
                }
            }catch {
                continuation.resume(throwing: error)
            }
        }
    }

    private func updatePhotoUrl(_ photo: Photo, url: String, completion: ((Error?)->Void)? = nil) throws {
        guard let userId = userId else {
            throw StoreError.notAuthorized
        }
        let ref = db.collection(userId).document("garden").collection("photos").document(photo.id)
        ref.updateData(["url":url], completion: completion)
    }

}
