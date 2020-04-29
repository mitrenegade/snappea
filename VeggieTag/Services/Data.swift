/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Helpers for loading images and data.
*/

import UIKit
import SwiftUI
import CoreLocation
import Firebase
import FirebaseFirestore

struct DataHelper {
    static func load<T: Decodable>(_ filename: String) -> T {
        let data: Data = loadJSONData(filename: filename)
        
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: data)
        } catch {
            fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
        }
    }
    
    static func loadJSONData(filename: String) -> Data {
        guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
            else {
                fatalError("Couldn't find \(filename) in main bundle.")
        }
        
        do {
            let data = try Data(contentsOf: file)
            return data
        } catch {
            fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
        }
    }
}


struct DataSample {
    static let db = Firestore.firestore()
    static let plantDict: [String:Plant] = DataHelper.load("plantData.json")
    static let tagDict: [String:Tag] = DataHelper.load("tagData.json")
    static let photoDict: [String: Photo] = DataHelper.load("photoData.json")
    
    static var photoData: [Photo] { return Array(DataSample.photoDict.values) }
    static var plantData: [Plant] { return Array(DataSample.plantDict.values) }
    static var tagData: [Tag] { return Array(DataSample.tagDict.values) }

    // do this once
    static func uploadTestData() {
        let photo = DataHelper.loadJSONData(filename: "photoData.json")
        let photoJSON = try! JSONSerialization.jsonObject(with: photo, options: .allowFragments) as! [String: Any]
        db.collection("photos").addDocument(data: photoJSON)

        let plant = DataHelper.loadJSONData(filename: "plantData.json")
        let plantJSON = try! JSONSerialization.jsonObject(with: plant, options: .allowFragments) as! [String: Any]
        db.collection("plants").addDocument(data: plantJSON)

        let tag = DataHelper.loadJSONData(filename: "tagData.json")
        let tagJSON = try! JSONSerialization.jsonObject(with: plant, options: .allowFragments) as! [String: Any]
        db.collection("tags").addDocument(data: tagJSON)
    }
}
