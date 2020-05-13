//
//  APIService.swift
//  SnapPea
//
//  Created by Bobby Ren on 4/29/20.
//  Copyright © 2020 RenderApps LLC. All rights reserved.
//

import Firebase
import FirebaseFirestore
import Combine

class APIService: NSObject, ObservableObject {
    static let shared = APIService()

    var photoCache: [String: Photo] = [:]
    var plantCache: [String: Plant] = [:]
    var tagCache: [String: Tag] = [:]
    
    @Published var photos: [Photo] = []
    @Published var plants: [Plant] = []
    @Published var tags: [Tag] = []
    
    let db: Firestore
    
    private let readWriteQueue: DispatchQueue = DispatchQueue(label: "io.renderapps.APIService.cache")

    init(db: Firestore = Firestore.firestore()) {
        self.db = db
    }
    
    // upload to db and save locally
    func addPhoto(_ photo: Photo) {
        self.store(photo: photo)
        photos = Array(photoCache.values)

        guard let userId = AuthenticationService.shared.user?.uid else { return }
        do {
            let result = try db.collection(userId).document("garden").collection("photos").addDocument(from: photo)
            print("AddPhoto result \(result)")
        } catch let error {
            print("AddPhoto error \(error)")
        }
    }

    func addPlant(_ plant: Plant) {
        self.store(plant: plant)
        plants = Array(plantCache.values)

        guard let userId = AuthenticationService.shared.user?.uid else { return }
        do {
            let result = try db.collection(userId).document("garden").collection("plants").addDocument(from: plant)
            print("AddPlant result \(result)")
        } catch let error {
            print("AddPlant error \(error)")
        }
    }

    func addTag(_ tag: Tag, result: @escaping ((Tag?, Error?)->Void)) {
        // TODO: also update plants and photos?
        guard let userId = AuthenticationService.shared.user?.uid else { return }
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
    
    func loadGarden() {
        guard let userId = AuthenticationService.shared.user?.uid else { return }
        db.collection(userId).document("garden").collection("photos").addSnapshotListener { (snapshot, error) in
            self.photos = snapshot?.documents.compactMap { document -> Photo? in
                if let object = try? document.data(as: Photo.self) {
                    self.store(photo: object)
                    return object
                }
                return nil
            } ?? []
            print("Loaded photos: \(self.photos)")
        }
        
        db.collection(userId).document("garden").collection("plants").addSnapshotListener { (snapshot, error) in
            self.plants = snapshot?.documents.compactMap{ document -> Plant? in
                if let object = try? document.data(as: Plant.self) {
                    self.store(plant: object)
                    return object
                }
                return nil
            } ?? []
            print("Loaded plants: \(self.plants)")
        }

        db.collection(userId).document("garden").collection("tags").addSnapshotListener { (snapshot, error) in
            self.tags = snapshot?.documents.compactMap{ document -> Tag? in
                if let object = try? document.data(as: Tag.self) {
                    self.store(tag: object)
                    return object
                }
                return nil
                
            } ?? []
            print("Loaded tags: \(self.tags)")
        }
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
        guard let userId = AuthenticationService.shared.user?.uid else { return }
        let photo = DataHelper.loadJSONData(filename: "photoData.json")
        let photoJSON = try! JSONSerialization.jsonObject(with: photo, options: .allowFragments) as! [String: [String:Any]]
        for (key, val) in photoJSON {
            db.collection(userId).document("garden").collection("photos").document(key).setData(val)
        }

        let plant = DataHelper.loadJSONData(filename: "plantData.json")
        let plantJSON = try! JSONSerialization.jsonObject(with: plant, options: .allowFragments) as! [String: [String:Any]]
        for (key, val) in plantJSON {
            db.collection(userId).document("garden").collection("plants").document(key).setData(val)
        }

        let tag = DataHelper.loadJSONData(filename: "tagData.json")
        let tagJSON = try! JSONSerialization.jsonObject(with: tag, options: .allowFragments) as! [String: [String:Any]]
        for (key, val) in tagJSON {
            db.collection(userId).document("garden").collection("tags").document(key).setData(val)
        }
    }
}
