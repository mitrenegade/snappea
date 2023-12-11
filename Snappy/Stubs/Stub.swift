import UIKit
import SwiftUI

enum Stub: String {
    case plants
    case tags
    case photos
    case user

    // MARK: - Properties

    var file: String {
        "\(fileName).\(fileExtension)"
    }

    private var fileName: String {
        switch self {
        case .plants:
            return "plantData"
        case .tags:
            return "tagData"
        case .photos:
            return "photoData"
        case .user:
            return rawValue
        }
    }

    private var fileExtension: String {
        "json"
    }


    static var photoData: [Photo] { return Array(Stub.photoDict.values) }
    static var plantData: [Plant] { return Array(Stub.plantDict.values) }
    static var tagData: [Tag] { return Array(Stub.tagDict.values) }

    static var plantDict: [String:Plant] = Stub.load(.plants)
    static var tagDict: [String:Tag] = Stub.load(.tags)
    static var photoDict: [String: Photo] = Stub.load(.photos)

    static func load<T: Decodable>(_ stub: Stub) -> T {
        let filename = stub.file
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
