//
//  APIService.swift
//  VeggieTag
//
//  Created by Bobby Ren on 4/29/20.
//  Copyright © 2020 RenderApps LLC. All rights reserved.
//

import Firebase
import FirebaseFirestore
import Combine

class APIService: NSObject, ObservableObject {
    static let shared = APIService()

    //var allPhotos: [String: Photo] = [:]
    //var allPlants: [String: Plant] = [:]
    //var allTags: [String: Tag] = [:]
    
    @Published var photos: [Photo] = []
    @Published var plants: [Plant] = []
    @Published var tags: [Tag] = []
    
    let db: Firestore
    
    private let readWriteQueue: DispatchQueue = DispatchQueue(label: "io.renderapps.APIService.cache")

    init(db: Firestore = Firestore.firestore()) {
        self.db = db
    }
    
    func loadGarden() {
        guard let userId = AuthenticationService.shared.user?.uid else { return }
        db.collection(userId).document("garden").collection("photos").addSnapshotListener { (snapshot, error) in
            self.photos = snapshot?.documents.compactMap { document -> Photo? in
                try? document.data(as: Photo.self)
            } ?? []
            print("Loaded photos: \(self.photos)")
//            for document in snapshot?.documents ?? [] {
//                if let photo = Photo(from: document) {
//                    self.store(photo: photo)
//                }
//            }
        }
        
        db.collection("plants").addSnapshotListener { (snapshot, error) in
            self.plants = snapshot?.documents.compactMap{ document -> Plant? in
                try? document.data(as: Plant.self)
            } ?? []
            print("Loaded plants: \(self.plants)")
//            for document in snapshot?.documents ?? [] {
//                if let plant = Plant(from: document) {
//                    self.store(plant: plant)
//                }
//            }
        }

        db.collection("tags").addSnapshotListener { (snapshot, error) in
            self.tags = snapshot?.documents.compactMap{ document -> Tag? in
                try? document.data(as: Tag.self)
            } ?? []
            print("Loaded tags: \(self.tags)")
//            for document in snapshot?.documents ?? [] {
//                if let tag = Tag(from: document) {
//                    self.store(tag: tag)
//                }
//            }
        }
    }
    
//    func store(photo: Photo) {
//        readWriteQueue.sync {
//            allPhotos[photo.id] = photo
//        }
//    }
//
//    func store(plant: Plant) {
//        readWriteQueue.sync {
//            allPlants[plant.id] = plant
//        }
//    }
//
//    func store(tag: Tag) {
//        readWriteQueue.sync {
//            allTags[tag.id] = tag
//        }
//    }
    
    
    // do this once
    func uploadTestData() {
//        guard let userId = AuthenticationService.shared.user?.uid else { return }
//        let photo = DataHelper.loadJSONData(filename: "photoData.json")
//        let photoJSON = try! JSONSerialization.jsonObject(with: photo, options: .allowFragments) as! [String: [String:Any]]
//        for (key, val) in photoJSON {
//            db.collection(userId).document("garden").collection("photos").document(key).setData(val)
//        }
//
//        let plant = DataHelper.loadJSONData(filename: "plantData.json")
//        let plantJSON = try! JSONSerialization.jsonObject(with: plant, options: .allowFragments) as! [String: [String:Any]]
//        for (key, val) in plantJSON {
//            db.collection("plants").document(key).setData(val)
//        }
//
//        let tag = DataHelper.loadJSONData(filename: "tagData.json")
//        let tagJSON = try! JSONSerialization.jsonObject(with: tag, options: .allowFragments) as! [String: [String:Any]]
//        for (key, val) in tagJSON {
//            db.collection("tags").document(key).setData(val)
//        }
    }
}
