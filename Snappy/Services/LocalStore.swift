//
//  LocalStore.swift
//  Snappy
//
//  Created by Bobby Ren on 1/9/24.
//  Copyright © 2024 RenderApps LLC. All rights reserved.
//

import Foundation
import UIKit

/// A local persistence and caching layer
/// Stores into local file structure as data
class LocalStore: Store {
    private var baseURL: URL {
        get throws {
            try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        }
    }

    private func subpath(_ type: String) -> URL {
        do {
            let url = try baseURL.appendingPathComponent("plant")
            do {
                if !FileManager.default.fileExists(atPath: url.path, isDirectory: nil) {
                    try FileManager.default.createDirectory(at: url, withIntermediateDirectories: false)
                }
            } catch {
                print("Could not create path but ignoring: \(error)")
            }
            return url
        } catch {
            fatalError("Could not access local store plant url: \(error)")
        }
    }

    func loadGarden() async throws {
        do {
            let plantPath = subpath("plant")
            let plants = try FileManager.default
                .contentsOfDirectory(atPath: plantPath.path)
                .compactMap { plantPath.appending(path: $0) }
            print("Plants: \(plants.count) \(plants)")
            try plants.forEach { url in
                let data = try Data(contentsOf: url)
                let plant = try JSONDecoder().decode(Plant.self, from: data)
                cachePlant(plant)
            }

            let snapPath = subpath("snap")
            let snaps = try FileManager.default
                .contentsOfDirectory(atPath: snapPath.path)
                .compactMap { snapPath.appending(path: $0) }
            print("Snaps: \(snaps.count) \(snaps)")
            try snaps.forEach { url in
                let data = try Data(contentsOf: url)
                let snap = try JSONDecoder().decode(Snap.self, from: data)
                cacheSnap(snap)
            }

            let photoPath = subpath("photo")
            let photos = try FileManager.default
                .contentsOfDirectory(atPath: photoPath.path)
                .compactMap { photoPath.appending(path: $0) }
            print("Photos: \(photos.count) \(photos)")
            try photos.forEach { url in
                let data = try Data(contentsOf: url)
                let photo = try JSONDecoder().decode(Photo.self, from: data)

                let image = try ImageStore().loadImage(name: photo.id)
                cachePhoto(photo, image: image)
            }
        } catch {
            print("Load garden error: \(error)")
            throw error
        }
    }

    /// Caching
    private var photoCache: [String: Photo] = [:]
    private var plantCache: [String: Plant] = [:]
    private var snapCache: [String: Snap] = [:]
    private let readWriteQueue: DispatchQueue = DispatchQueue(label: "io.renderapps.APIService.cache")
    private var imageCache = TemporaryImageCache()
    private let imageStore = ImageStore()

    // MARK: -

    var allPhotos: [Photo] { Array(photoCache.values) }
    var allPlants: [Plant] { Array(plantCache.values) }
    var allSnaps: [Snap] { Array(snapCache.values) }

    // MARK: - Fetch

    func photo(withId id: String) -> Photo? {
        photoCache[id]
    }

    func plant(withId id: String) -> Plant? {
        plantCache[id]
    }

    func snap(withId id: String) -> Snap? {
        snapCache[id]
    }

    // MARK: - Relationships

    func snaps(for photo: Photo) -> [Snap] {
        let snaps = snapCache
            .compactMap { $0.value }
            .filter{ $0.photoId == photo.id }
        return Array(snaps)
    }

    func snaps(for plant: Plant) -> [Snap] {
        readWriteQueue.sync {
            let snaps = snapCache
                .compactMap { $0.value }
                .filter{ $0.plantId == plant.id }
            return Array(snaps)
        }
    }

    func plants(for photo: Photo) -> [Plant] {
        readWriteQueue.sync {
            let snaps = snaps(for: photo)
            let plants = snaps.compactMap { plant(withId: $0.plantId) }
            return Array(Set(plants))
        }
    }

    func photos(for plant: Plant) -> [Photo] {
        readWriteQueue.sync {
            let snaps = snaps(for: plant)
            let photos = snaps.compactMap { photo(withId:$0.photoId) }
            return Array(Set(photos))
        }
    }

    // MARK: - Saving

    public func createPhoto(image: UIImage) throws -> Photo {
        let id = UUID().uuidString
        let timestamp = Date().timeIntervalSince1970
        let photo = Photo(id: id, timestamp: timestamp)

        let url = try baseURL.appending(path: "photo").appending(path: photo.id)
        try imageStore.saveImage(image, name: photo.id)
        let data = try JSONEncoder().encode(photo)
        try data.write(to: url, options: [.atomic, .completeFileProtection])

        cachePhoto(photo, image: image)

        return photo
    }

    public func createPlant(name: String, type: PlantType, category: Category) throws {
        let id = UUID().uuidString
        let plant = Plant(id: id, name: name, type: type, category: category)
        let url = try baseURL.appending(path: "plant").appending(path: plant.id)
        let data = try JSONEncoder().encode(plant)
        try data.write(to: url, options: [.atomic, .completeFileProtection])

        cachePlant(plant)
    }

    public func createSnap(photo: Photo, start: CGPoint, end: CGPoint, imageSize: CGSize) throws -> Snap{
        let (startCoord, endCoord) = CoordinateService.getValidCoordinatesFromPixels(imageSize: imageSize, start: start, end: end)

        print("createSnap startCoord: \(startCoord) endCoord \(endCoord)")

        let snap = Snap(photoId: photo.id, start: startCoord, end: endCoord)
        let url = try baseURL.appending(path: "snap").appending(path: snap.id)
        let data = try JSONEncoder().encode(snap)
        try data.write(to: url, options: [.atomic, .completeFileProtection])

        cacheSnap(snap)

        return snap
    }

    // MARK: - Caching

    private func cachePhoto(_ photo: Photo, image: UIImage) {
        readWriteQueue.sync {
            photoCache[photo.id] = photo
            imageCache[photo.id] = image
        }
    }

    private func cachePlant(_ plant: Plant) {
        readWriteQueue.sync {
            plantCache[plant.id] = plant
        }
    }

    private func cacheSnap(_ snap: Snap) {
        readWriteQueue.sync {
            snapCache[snap.id] = snap
        }
    }

}

