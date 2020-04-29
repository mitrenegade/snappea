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

let db = Firestore.firestore()
let plantData: [Plant] = DataHelper.load("plantData.json")
let tagData: [Tag] = DataHelper.load("tagData.json")
let photoData: [Photo] = DataHelper.load("photoData.json")

struct DataSample {
    // do this once
    static func uploadTestData() {
        let photo = DataHelper.loadJSONData(filename: "photoData.json")
        let photoJSON = try! JSONSerialization.jsonObject(with: photo, options: .allowFragments) as! [String: Any]
        db.collection("photo").addDocument(data: photoJSON)
    }
}
