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
    func createPhoto(image: UIImage) throws -> Photo {
        let id = UUID().uuidString // TODO use firebase id
        let timestamp = Date().timeIntervalSince1970
        let photo = Photo(id: id, timestamp: timestamp)
        try addPhoto(photo) { result, error in
            guard var newPhoto = result else {
                return
            }
            FirebaseImageService.uploadImage(image: image, type: .photo, uid: photo.id) { [weak self] result in
                if let url = result {
                    do {
                        try self?.updatePhotoUrl(newPhoto, url: url) { error in
                            newPhoto.url = url // manually update url in existing photo object locally
                        }
                    } catch {
                        print("Update photo \(error)")
                    }
                }
            }
        }

        return photo
    }

    func createPlant(name: String, type: PlantType, category: Category) throws {
    }

    func createSnap(photo: Photo, start: CGPoint, end: CGPoint, imageSize: CGSize) throws -> Snap {
        // BR TODO
        fatalError()
    }
}

/// Direct calls to API
extension FirebaseStore {
    private var userId: String? {
        auth.user?.id
    }

    // MARK: - API Interface
    private func fetchPhotos() async throws -> [Photo] {
        try await fetchObjects(collection: "photos")
    }

    private func fetchPlants() async throws -> [Plant] {
        try await fetchObjects(collection: "plants")
    }

    private func fetchSnaps() async throws -> [Snap] {
        try await fetchObjects(collection: "snaps")
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
    private func add<T: Codable>(_ object: T,
                                   collection: String,
                                   completion: @escaping ((T?, Error?)->Void)) throws {
        guard let userId = userId else {
            throw StoreError.notAuthorized
        }
        do {
            let ref = try db.collection(userId)
                .document("garden").collection(collection)
                .addDocument(from: object)
            ref.getDocument { (snapshot, error) in
                if let result = try? snapshot?.data(as: T.self) {
                    completion(result, error)
                }
            }
        } catch let error {
            print("AddPhoto error \(error)")
        }
    }

    private func updatePhotoUrl(_ photo: Photo, url: String, completion: ((Error?)->Void)? = nil) throws {
        guard let userId = userId else {
            throw StoreError.notAuthorized
        }
        let ref = db.collection(userId).document("garden").collection("photos").document(photo.id)
        ref.updateData(["url":url], completion: completion)
    }

    // only creates Photo object; image upload and url update are done separately
    private func addPhoto(_ photo: Photo, result: @escaping ((Photo?, Error?)->Void)) throws {
        try add(photo, collection: "photos", completion: result)
    }

    private func addPlant(_ plant: Plant, result: @escaping ((Plant?, Error?)->Void)) throws {
        try add(plant, collection: "plants", completion: result)
    }

    private func addSnap(_ snap: Snap, result: @escaping ((Snap?, Error?)->Void)) throws {
        // TODO: also update plants and photos?
        try add(snap, collection: "snaps", completion: result)
    }
}
