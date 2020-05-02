//
//  APIService.swift
//  VeggieTag
//
//  Created by Bobby Ren on 4/29/20.
//  Copyright © 2020 RenderApps LLC. All rights reserved.
//

import Firebase
import FirebaseFirestore

class APIService: NSObject {
    static let shared = APIService()
    /*
    static var photoData: [Photo] { return Array(APIService.shared.photoDict.values) }
    static var plantData: [Plant] { return Array(APIService.shared.plantDict.values) }
    static var tagData: [Tag] { return Array(APIService.shared.tagDict.values) }

    var plantDict: [String:Plant] = DataHelper.load("plantData.json")
    var tagDict: [String:Tag] = DataHelper.load("tagData.json")
    var photoDict: [String: Photo] = DataHelper.load("photoData.json")
    */

    var allPhotos: [String: Photo] = [:]
    var allPlants: [String: Plant] = [:]
    var allTags: [String: Tag] = [:]
    
    let db: Firestore
    
    private let readWriteQueue: DispatchQueue = DispatchQueue(label: "io.renderapps.APIService.cache")

    init(db: Firestore = Firestore.firestore()) {
        self.db = db
    }
    
    func loadGarden() {
        db.collection("photos").getDocuments { (snapshot, error) in
            print("Loaded photos: \(snapshot?.documents)")
            for document in snapshot?.documents ?? [] {
                if let photo = Photo(from: document) {
                    self.store(photo: photo)
                }
            }
        }
        
        db.collection("plants").getDocuments { (snapshot, error) in
            print("Loaded plants: \(snapshot?.documents)")
            for document in snapshot?.documents ?? [] {
                if let plant = Plant(from: document) {
                    self.store(plant: plant)
                }
            }
        }

        db.collection("tags").getDocuments { (snapshot, error) in
            print("Loaded tags: \(snapshot?.documents)")
            for document in snapshot?.documents ?? [] {
                if let tag = Tag(from: document) {
                    self.store(tag: tag)
                }
            }
        }
    }
    
    func store(photo: Photo) {
        readWriteQueue.sync {
            allPhotos[photo.id] = photo
        }
    }
    
    func store(plant: Plant) {
        readWriteQueue.sync {
            allPlants[plant.id] = plant
        }
    }
    
    func store(tag: Tag) {
        readWriteQueue.sync {
            allTags[tag.id] = tag
        }
    }
    
    
    // do this once
    /*
    static func uploadTestData() {
        let photo = DataHelper.loadJSONData(filename: "photoData.json")
        let photoJSON = try! JSONSerialization.jsonObject(with: photo, options: .allowFragments) as! [String: [String:Any]]
        for (key, val) in photoJSON {
            db.collection("photos").document(key).setData(val)
        }

        let plant = DataHelper.loadJSONData(filename: "plantData.json")
        let plantJSON = try! JSONSerialization.jsonObject(with: plant, options: .allowFragments) as! [String: [String:Any]]
        for (key, val) in plantJSON {
            db.collection("plants").document(key).setData(val)
        }
        
        let tag = DataHelper.loadJSONData(filename: "tagData.json")
        let tagJSON = try! JSONSerialization.jsonObject(with: tag, options: .allowFragments) as! [String: [String:Any]]
        for (key, val) in tagJSON {
            db.collection("tags").document(key).setData(val)
        }
    }
     */
}
