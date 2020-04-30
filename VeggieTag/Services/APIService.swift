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
    static let db = Firestore.firestore()
    static let plantDict: [String:Plant] = DataHelper.load("plantData.json")
    static let tagDict: [String:Tag] = DataHelper.load("tagData.json")
    static let photoDict: [String: Photo] = DataHelper.load("photoData.json")
    
    static var photoData: [Photo] { return Array(APIService.photoDict.values) }
    static var plantData: [Plant] { return Array(APIService.plantDict.values) }
    static var tagData: [Tag] { return Array(APIService.tagDict.values) }

    func loadGarden() {
        APIService.db.collection("photos").getDocuments { (snapshot, error) in
            print("Loaded photos: \(snapshot?.documents)")
            for document in snapshot?.documents ?? [] {
                print("Document \(document)")
            }
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
