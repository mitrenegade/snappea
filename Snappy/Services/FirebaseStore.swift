//
//  FirebaseStore.swift
//  Snappy
//
//  Created by Bobby Ren on 1/14/24.
//  Copyright © 2024 RenderApps LLC. All rights reserved.
//

import Foundation
import UIKit

/// An implementation of Store that uses Firebase's API, via FirebaseAPIService
class FirebaseStore: Store {

    private let api = FirebaseAPIService()

    func loadGarden() async throws {
        let group = DispatchGroup()
        Task {
            group.enter()
            allPhotos = try await api.fetchPhotos()
        }
        Task {
            group.enter()
            allPlants = try await api.fetchPlants()
        }
        Task {
            group.enter()
            allSnaps = try await api.fetchSnaps()
        }
        group.notify(queue: DispatchQueue.global()) {
            print("Load garden complete with \(self.allPhotos.count) photos, \(self.allPlants.count) plants, \(self.allSnaps.count) snaps")
        }
    }

    var allPhotos: [Photo] = []

    var allPlants: [Plant] = []

    var allSnaps: [Snap] = []

    func photo(withId id: String) -> Photo? {
        nil
    }

    func plant(withId id: String) -> Plant? {
        nil
    }

    func snap(withId id: String) -> Snap? {
        nil
    }

    func store(photo: Photo, image: UIImage?) {
        api.addPhoto(photo) { result, error in
            guard var newPhoto = result,
                  let image = image else {
              return
          }
            FirebaseImageService.uploadImage(image: image, type: .photo, uid: photo.id) { [weak self] result in
                if let url = result {
                    self?.api.updatePhotoUrl(newPhoto, url: url) { error in
                        newPhoto.url = url // manually update url in existing photo object locally
                    }
                }
            }
        }
        // no op
    }

    func store(plant: Plant) {
        // no op
    }

    func store(snap: Snap) {
        // no op
    }

    func snaps(for plant: Plant) -> [Snap] {
        []
    }

    func snaps(for photo: Photo) -> [Snap] {
        []
    }

    func plants(for photo: Photo) -> [Plant] {
        []
    }

    func photos(for plant: Plant) -> [Photo] {
        []
    }
}

