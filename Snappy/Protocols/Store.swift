//
//  Store.swift
//  Snappy
//
//  Created by Bobby Ren on 12/14/23.
//  Copyright © 2023 RenderApps LLC. All rights reserved.
//

import Foundation
import UIKit

/// Data layer that is responsible for API or Cache
/// Top level interface to the client that abstracts whether the data comes from local
/// store, an API interface, or is mocked
protocol Store {
    func loadGarden() async throws

    var allPhotos: [Photo] { get }
    var allPlants: [Plant] { get }
    var allSnaps: [Snap] { get }

    func photo(withId id: String) -> Photo?
    func plant(withId id: String) -> Plant?
    func snap(withId id: String) -> Snap?

    func store(photo: Photo, image: UIImage?)
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

