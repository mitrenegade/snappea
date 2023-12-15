//
//  MockDataStore.swift
//  Snappy
//
//  Created by Bobby Ren on 12/14/23.
//  Copyright © 2023 RenderApps LLC. All rights reserved.
//

import Foundation

class MockDataStore: DataStore {
    func store(photo: Photo) {
        // no op
    }

    func store(plant: Plant) {
        // no op
    }

    func store(snap: Snap) {
        // no op
    }

    func photo(withId id: String) -> Photo? {
        Stub.photoData.first { $0.id == id }
    }
    
    func plant(withId id: String) -> Plant? {
        Stub.plantData.first { $0.id == id }
    }
    
    func snap(withId id: String) -> Snap? {
        Stub.snapData.first { $0.id == id }
    }

    /// Relationships
    func snaps(for photo: Photo) -> [Snap] {
        let snaps = Stub.snapData
            .filter{ $0.photoId == photo.id }
        return Array(snaps)
    }

    func snaps(for plant: Plant) -> [Snap] {
        let snaps = Stub.snapData
            .filter{ $0.plantId == plant.id }
        return Array(snaps)
    }

    func plants(for photo: Photo) -> [Plant] {
        let snaps = snaps(for: photo)
        let plants = snaps.compactMap { plant(withId: $0.plantId) }
        return Array(Set(plants))
    }

    func photos(for plant: Plant) -> [Photo] {
        let snaps = snaps(for: plant)
        let photos = snaps.compactMap { photo(withId:$0.photoId) }
        return Array(Set(photos))
    }
}
