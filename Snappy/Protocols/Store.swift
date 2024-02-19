//
//  Store.swift
//  Snappy
//
//  Created by Bobby Ren on 12/14/23.
//  Copyright © 2023 RenderApps LLC. All rights reserved.
//

import Foundation
import UIKit

enum StoreError: Error {
    case notAuthorized
    case databaseError(Error?)
}

/// Data layer that is responsible for API or Cache
/// Top level interface to the client that abstracts whether the data comes from local
/// store, an API interface, or is mocked
protocol Store: ObservableObject {
    var isLoading: Bool { get }
    func loadGarden(id: String) async throws

    // MARK: - ObservedObject
    // see https://medium.com/expedia-group-tech/observableobject-published-and-protocols-with-swiftui-uikit-and-cuckoo-cce69a47f08a
    var allPlants: [Plant] { get }
    var allPlantsValue: Published<[Plant]> { get }
    var allPlantsPublisher: Published<[Plant]>.Publisher { get }

    var allPhotos: [Photo] { get }
    var allPhotosValue: Published<[Photo]> { get }
    var allPhotosPublisher: Published<[Photo]>.Publisher { get }

    var allSnaps: [Snap] { get }
    var allSnapsValue: Published<[Snap]> { get }
    var allSnapsPublisher: Published<[Snap]>.Publisher { get }

    // MARK: - Fetch

    func photo(withId id: String) -> Photo?
    func plant(withId id: String) -> Plant?
    func snap(withId id: String) -> Snap?

    // MARK: - Relationships

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

    // MARK: - Creating

    @discardableResult func createPlant(name: String, type: PlantType, category: Category) async throws -> Plant

    @discardableResult func createPhoto(image: UIImage) async throws -> Photo

    @discardableResult func createSnap(photo: Photo, start: NormalizedCoordinate, end: NormalizedCoordinate) async throws -> Snap
}

