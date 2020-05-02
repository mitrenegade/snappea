/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Helpers for loading images and data.
*/

import UIKit
import SwiftUI

struct DataHelper {
    static var photoData: [Photo] { return Array(DataHelper.photoDict.values) }
    static var plantData: [Plant] { return Array(DataHelper.plantDict.values) }
    static var tagData: [Tag] { return Array(DataHelper.tagDict.values) }

    static var plantDict: [String:Plant] = DataHelper.load("plantData.json")
    static var tagDict: [String:Tag] = DataHelper.load("tagData.json")
    static var photoDict: [String: Photo] = DataHelper.load("photoData.json")

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
