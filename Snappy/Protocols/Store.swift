//
//  Store.swift
//  Snappy
//
//  Created by Bobby Ren on 12/14/23.
//  Copyright © 2023 RenderApps LLC. All rights reserved.
//

import Foundation

/// Data layer that is responsible for API or Cache
protocol Store {
    var allPhotos: [Photo] { get }
    var allPlants: [Plant] { get }
    var allSnaps: [Snap] { get }

    func photo(withId id: String) -> Photo?
    func plant(withId id: String) -> Plant?
    func snap(withId id: String) -> Snap?

    /// Cache
    func store(photo: Photo)
    func store(plant: Plant)
    func store(snap: Snap)

    /// Each plant has a collection of snaps
    func snaps(for plant: Plant) -> [Snap]

    /// Each photo has a collection of snaps.
    func snaps(for photo: Photo) -> [Snap]

    /// A photo can have multiple plants. The relationship
    /// is determined by the snaps of that photo
    func plants(for photo: Photo) -> [Plant]

    /// A plant can have multiple photos. The relationship
    /// is determined by the snaps of that plant
    func photos(for plant: Plant) -> [Photo]
}

