import UIKit
import SwiftUI

enum Stub: String {
    case plants
    case snaps
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
        case .snaps:
            return "snapData"
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
    static var snapData: [Tag] { return Array(Stub.snapDict.values) }

    static var plantDict: [String:Plant] = Stub.load(.plants)
    static var snapDict: [String:Tag] = Stub.load(.snaps)
    static var photoDict: [String: Photo] = Stub.load(.photos)

    static var testUser: User = Stub.load(.user)

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
