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
    var isLoading: Bool = false
    private var userId: String = ""

    func setup(id: String) {
        // no op - auth already takes care of base URL and auth
        userId = id
    }
    
    // MARK: - Store as an ObservedObject
    @Published var allPlants: [Plant] = []
    var allPlantsValue: Published<[Plant]> {
        return _allPlants
    }
    var allPlantsPublisher: Published<[Plant]>.Publisher {
        return $allPlants
    }

    @Published var allPhotos: [Photo] = []
    var allPhotosValue: Published<[Photo]> {
        return _allPhotos
    }
    var allPhotosPublisher: Published<[Photo]>.Publisher {
        return $allPhotos
    }

    @Published var allSnaps: [Snap] = []
    var allSnapsValue: Published<[Snap]> {
        return _allSnaps
    }
    var allSnapsPublisher: Published<[Snap]>.Publisher {
        return $allSnaps
    }

    // MARK: - Firebase Functionality

    /// Firebase Database
    let db = Firestore.firestore()

    func loadGarden() async throws {
        // TODO: retain listener and clear on logout
        observePlants()
        observePhotos()
        observeSnaps()
    }

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

    func createSnap(plant: Plant, photo: Photo, start: NormalizedCoordinate, end: NormalizedCoordinate) async throws -> Snap {
        let snap = try await addSnap(plantId: plant.id, photoId: photo.id, start: start, end: end)
        return snap
    }

    func updateSnap(snap: Snap, start: NormalizedCoordinate, end: NormalizedCoordinate) async throws -> Snap? {
        // TODO: locate and update document in firestore
        return nil
    }

    func updateSnap(snap: Snap, plant: Plant) async throws -> Snap? {
        // TODO: locate and update document in firestore
        return nil
    }

}

/// Direct calls to API
extension FirebaseStore {

    private var baseDocument: DocumentReference {
        db.collection(userId).document("garden")
    }

    // MARK: - Upload async/await

    /// Creates a Photo object in firebase
    /// Note: image upload and url update are done separately
    private func addPhoto(timestamp: Double) async throws -> Photo {
        return try await add(collection: .photo, data: ["timestamp": timestamp])
    }

    private func addPlant(name: String, type: PlantType, category: Category) async throws -> Plant {
        let data: [String: Any] = ["name": name, "type": type.rawValue, "category": category.rawValue]
        return try await add(collection: .plant, data: data)
    }

    private func addSnap(plantId: String, photoId: String, start: NormalizedCoordinate, end: NormalizedCoordinate) async throws -> Snap {
        let data: [String: Any] = ["plantId": plantId,
                                   "photoId": photoId,
                                   "start": ["x": start.x, "y": start.y],
                                   "end": ["x": end.x, "y": end.y]]
        return try await add(collection: .snap, data: data)
    }

    // MARK: - Generic interface into Firebase

    // upload to db and save locally
    private func add<T: Codable>(collection: StoreObject, data: [String: Any]) async throws -> T {
        let ref = try await baseDocument.collection(collection.rawValue)
            .addDocument(data: data)
        try await ref.updateData(["id": ref.documentID])

        let snapshot = try await ref.getDocument()
        let result = try snapshot.data(as: T.self)
        return result
    }

    private func updatePhotoUrl(_ photo: Photo, url: String, completion: ((Error?)->Void)? = nil) throws {
        let ref = baseDocument.collection(StoreObject.photo.rawValue).document(photo.id)
        ref.updateData(["url":url], completion: completion)
    }

    // Listening to objects to update automatically
    private func observePlants() {
        let completion: ((Result<[Plant], Error>) -> Void) = { [weak self] result in
            switch result {
            case .success(let plants):
                print("BRDEBUG Observed plants \(plants.count)")
                self?.allPlants = plants
            case .failure(let error):
                print("BRDEBUG Observe plants failed with error \(error))")
            }
        }
        observe(type: .plant, completion: completion)
    }

    private func observePhotos() {
        let completion: ((Result<[Photo], Error>) -> Void) = { [weak self] result in
            switch result {
            case .success(let results):
                print("BRDEBUG Observed photos \(results.count)")
                self?.allPhotos = results
            case .failure(let error):
                print("BRDEBUG Observe photos failed with error \(error))")
            }
        }
        observe(type: .photo, completion: completion)
    }

    private func observeSnaps() {
        let completion: ((Result<[Snap], Error>) -> Void) = { [weak self] result in
            switch result {
            case .success(let results):
                print("BRDEBUG Observed snaps \(results.count)")
                self?.allSnaps = results
            case .failure(let error):
                print("BRDEBUG Observe snaps failed with error \(error))")
            }
        }
        observe(type: .snap, completion: completion)
    }

    // generic listener and decoder for Firebase objects of type T
    @discardableResult private func observe<T: Decodable>(type: StoreObject, completion: @escaping ((Result<[T], Error>) -> Void)) -> ListenerRegistration {
        let listener = baseDocument.collection(type.rawValue).addSnapshotListener { querySnapshot, error in
            if let documents = querySnapshot?.documents {
                let objects = documents.compactMap { document -> T? in
                    try? document.data(as: T.self)
                }
                completion(.success(objects))
            } else {
                completion(.failure(StoreError.databaseError(error)))
            }
        }
        return listener
    }
}

extension FirebaseStore {
    // MARK: - One time fetch

    /// Fetches an array of an object type given a collection name
    /// Performs this fetch once
    private func fetchObjects<T: Decodable>(collection: StoreObject) async throws -> [T] {
        let snapshot = try await baseDocument.collection(collection.rawValue).getDocuments()

        print("BRDEBUG collection \(collection) objects \(snapshot.count)")
        let objects = snapshot.documents.compactMap { document -> T? in
            try? document.data(as: T.self)
        }
        return objects
    }

    private func fetchPhotos() async throws -> [Photo] {
        try await fetchObjects(collection: .photo)
    }

    private func fetchPlants() async throws -> [Plant] {
        try await fetchObjects(collection: .plant)
    }

    private func fetchSnaps() async throws -> [Snap] {
        try await fetchObjects(collection: .snap)
    }

}
