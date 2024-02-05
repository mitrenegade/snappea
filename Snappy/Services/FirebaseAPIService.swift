//
//  FirebaseAPIService.swift
//  Snappy
//
//  Created by Bobby Ren on 1/9/24.
//  Copyright © 2024 RenderApps LLC. All rights reserved.
//

import Foundation
import RenderCloud
import Combine
import Firebase

/// The actual interface into Firebase
class FirebaseAPIService {
    static let shared = FirebaseAPIService()

    /// Auth
    private let auth: AuthStore
    private var userId: String? {
        auth.user?.id
    }

    /// Firebase
    private let db = Firestore.firestore()

    // MARK: - Initialization
    init(authStore: AuthStore = AuthStore.shared) {
        self.auth = authStore
    }

    // MARK: - API Interface
    func fetchPhotos() async throws -> [Photo] {
        let photos: [Photo] = try await fetchObjects(collection: "photos")
        return photos
    }

    func fetchPlants() async throws -> [Plant] {
        let plants: [Plant] = try await fetchObjects(collection: "plants")
        return plants
    }

    func fetchSnaps() async throws -> [Snap] {
        let snaps: [Snap] = try await fetchObjects(collection: "snaps")
        return snaps
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
    func addPhoto(_ photo: Photo, completion: @escaping ((Photo?, Error?)->Void)) {
//        do {
//            let ref = try db.collection(userId).document("garden").collection("photos").addDocument(from: photo)
//            ref.getDocument { (snapshot, error) in
//                if let photo: Photo = try? snapshot?.data(as: Photo.self) {
//                    self.store(photo: photo)
//                    completion(photo, error)
//                }
//            }
//        } catch let error {
//            print("AddPhoto error \(error)")
//        }
    }

    func updatePhotoUrl(_ photo: Photo, url: String, completion: ((Error?)->Void)? = nil) {
//        guard let id = photo.id else { return }
//        let ref = db.collection(userId).document("garden").collection("photos").document(id)
//        ref.updateData(["url":url], completion: completion)
    }

    func addPlant(_ plant: Plant) {
//        self.store(plant: plant)
//        plants = Array(plantCache.values)
//
//        do {
//            let result = try db.collection(userId).document("garden").collection("plants").addDocument(from: plant)
//            print("AddPlant result \(result)")
//        } catch let error {
//            print("AddPlant error \(error)")
//        }
    }

    func addSnap(_ snap: Snap, result: @escaping ((Snap?, Error?)->Void)) {
        // TODO: also update plants and photos?
//        do {
//            let ref = try db.collection(userId).document("garden").collection("snaps").addDocument(from: snap)
//            print("AddSnap result \(ref)")
//            ref.getDocument { (snapshot, error) in
//                if let snap: Snap = try? snapshot?.data(as: Snap.self) {
//                    self.store(tag: tag)
//                    result(tag, error)
//                }
//            }
//        } catch let error {
//            print("AddSnap error \(error)")
//        }
    }

    // do this once
    func uploadTestData() {
        /*
        guard let userId = AuthStore.shared.user?.id else { return }
        let photo = Stub.loadJSONData(filename: "photoData.json")
        let photoJSON = try! JSONSerialization.jsonObject(with: photo, options: .allowFragments) as! [String: [String:Any]]
        for (key, val) in photoJSON {
            db.collection(userId).document("garden").collection("photos").document(key).setData(val)
        }

        let plant = Stub.loadJSONData(filename: "plantData.json")
        let plantJSON = try! JSONSerialization.jsonObject(with: plant, options: .allowFragments) as! [String: [String:Any]]
        for (key, val) in plantJSON {
            db.collection(userId).document("garden").collection("plants").document(key).setData(val)
        }

        let snap = Stub.loadJSONData(filename: "snapData.json")
        let snapJSON = try! JSONSerialization.jsonObject(with: snap, options: .allowFragments) as! [String: [String:Any]]
        for (key, val) in snapJSON {
            db.collection(userId).document("garden").collection("snaps").document(key).setData(val)
        }
         */
    }
}
