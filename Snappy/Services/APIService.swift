//
//  APIService.swift
//  Snappy
//
//  Created by Bobby Ren on 4/29/20.
//  Copyright © 2020 RenderApps LLC. All rights reserved.
//

import RenderCloud
import Combine

class APIService: NSObject, ObservableObject {
    static let shared = APIService()

    var photoCache: [String: Photo] = [:]
    var plantCache: [String: Plant] = [:]
    var tagCache: [String: Tag] = [:]
    
    @Published var photos: [Photo] = []
    @Published var plants: [Plant] = []
    @Published var snaps: [Tag] = []

    private let dataStore: DataStore

    private let readWriteQueue: DispatchQueue = DispatchQueue(label: "io.renderapps.APIService.cache")

    init(dataStore: DataStore = FirebaseDataStore()) {
        self.dataStore = dataStore
    }
    
    // upload to db and save locally
    func addPhoto(_ photo: Photo, completion: @escaping ((Photo?, Error?)->Void)) {
        do {
            let ref = try db.collection(userId).document("garden").collection("photos").addDocument(from: photo)
            ref.getDocument { (snapshot, error) in
                if let photo: Photo = try? snapshot?.data(as: Photo.self) {
                    self.store(photo: photo)
                    completion(photo, error)
                }
            }
        } catch let error {
            print("AddPhoto error \(error)")
        }
    }

    func updatePhotoUrl(_ photo: Photo, url: String, completion: ((Error?)->Void)? = nil) {
        guard let id = photo.id else { return }
        let ref = db.collection(userId).document("garden").collection("photos").document(id)
        ref.updateData(["url":url], completion: completion)
    }
    
    func addPlant(_ plant: Plant) {
        self.store(plant: plant)
        plants = Array(plantCache.values)

        do {
            let result = try db.collection(userId).document("garden").collection("plants").addDocument(from: plant)
            print("AddPlant result \(result)")
        } catch let error {
            print("AddPlant error \(error)")
        }
    }

    func addTag(_ tag: Tag, result: @escaping ((Tag?, Error?)->Void)) {
        // TODO: also update plants and photos?
        do {
            let ref = try db.collection(userId).document("garden").collection("tags").addDocument(from: tag)
            print("AddTag result \(ref)")
            ref.getDocument { (snapshot, error) in
                if let tag: Tag = try? snapshot?.data(as: Tag.self) {
                    self.store(tag: tag)
                    result(tag, error)
                }
            }
        } catch let error {
            print("AddTag error \(error)")
        }
    }
    
    func loadGarden() async throws {
        self.photos = try await dataStore.fetchPhotos()
//        store(photo: photos)
        self.plants = try await dataStore.fetchPlants()
//        store(plant: plants)
        self.snaps = try await dataStore.fetchSnaps()
        // store(snaps: snaps)
    }
    
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

    private func store(tag: Tag) {
        readWriteQueue.sync {
            if let id = tag.id {
                tagCache[id] = tag
            }
        }
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
