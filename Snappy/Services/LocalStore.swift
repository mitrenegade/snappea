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
            try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        }
    }

    func loadGarden() async throws {
//        for photo in Stub.photoData {
//            store(photo: photo, image: nil)
//        }
//        for plant in Stub.plantData {
//            store(plant: plant)
//        }
//        for snap in Stub.snapData {
//            store(snap: snap)
//        }

        let plants = try FileManager.default
            .contentsOfDirectory(atPath: baseURL.appending(path: "photo").absoluteString)
            .compactMap { URL(string: $0) }
        try plants.forEach { url in
            let data = try Data(contentsOf: url)
            let plant = try JSONDecoder().decode(Plant.self, from: data)
            cachePlant(plant)
        }

        let snaps = try FileManager.default
            .contentsOfDirectory(atPath: baseURL.appending(path: "snap").absoluteString)
            .compactMap { URL(string: $0) }
        try snaps.forEach { url in
            let data = try Data(contentsOf: url)
            let snap = try JSONDecoder().decode(Snap.self, from: data)
            cacheSnap(snap)
        }

        let photos = try FileManager.default
            .contentsOfDirectory(atPath: baseURL.appending(path: "photo").absoluteString)
            .compactMap { URL(string: $0) }
        try photos.forEach { url in
            let data = try Data(contentsOf: url)
            let photo = try JSONDecoder().decode(Photo.self, from: data)

            let image = try ImageStore().loadImage(name: photo.id)
            cachePhoto(photo, image: image)
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

    public func store(photo: Photo, image: UIImage?) {
        guard let image else {
            return
        }

        do {
            let url = try baseURL.appending(path: "photo").appending(path: photo.id)
            try imageStore.saveImage(image, name: photo.id)
            let data = try JSONEncoder().encode(photo)
            try data.write(to: url, options: [.atomic, .completeFileProtection])
        } catch {
            print("Write error")
        }

        cachePhoto(photo, image: image)
    }

    public func store(plant: Plant) {
        do {
            let url = try baseURL.appending(path: "plant").appending(path: plant.id)
            let data = try JSONEncoder().encode(plant)
            try data.write(to: url, options: [.atomic, .completeFileProtection])
        } catch {
            print("Write error")
        }

        cachePlant(plant)
    }

    public func store(snap: Snap) {
        do {
            let url = try baseURL.appending(path: "snap").appending(path: snap.id)
            let data = try JSONEncoder().encode(snap)
            try data.write(to: url, options: [.atomic, .completeFileProtection])
        } catch {
            print("Write error")
        }

        cacheSnap(snap)
    }

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

    // MARK: - Saving

    public func createPlant(name: String, type: PlantType, category: Category) {
        let id = UUID().uuidString
        let plant = Plant(id: id, name: name, type: type, category: category)
        store(plant: plant)
    }
}

