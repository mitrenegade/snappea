//
//  LocalStoreTests.swift
//  SnappyTests
//
//  Created by Bobby Ren on 3/16/24.
//  Copyright © 2024 RenderApps LLC. All rights reserved.
//

import XCTest
import Combine
@testable import Snappy

final class LocalStoreTests: XCTestCase {

    private var store: LocalStore!

    @MainActor
    override func setUpWithError() throws {
        store = LocalStore()
        store.purge(id: "test")
    }

    override func tearDownWithError() throws {
        store.purge(id: "test")
        store = nil
    }

    @MainActor
    func testLoadGarden() async throws {
        store.setup(gardenID: "test")
        try await store.loadGarden()
        XCTAssertFalse(store.isLoading)
        var pathComponents = store.imageBaseURL.pathComponents
        XCTAssert(pathComponents.contains("image"))
        XCTAssert(pathComponents.contains("Documents"))
        XCTAssertEqual(pathComponents.popLast(), "image")
        XCTAssertEqual(pathComponents.popLast(), "test")
    }

    @MainActor
    func testCreatePlant() async throws {
        store.setup(gardenID: "test")
        try await store.loadGarden()

        _ = try await store.createPlant(name: "abc", type: .cucumber, category: .cucurbit)
        XCTAssertEqual(store.allPlants.count, 1)
    }

    @MainActor
    func testCreatePhoto() async throws {
        store.setup(gardenID: "test")
        try await store.loadGarden()

        let image = UIImage(named: "peas")!
        _ = try await store.createPhoto(image: image)
        XCTAssertEqual(store.allPhotos.count, 1)
    }

    /* FIXME: published subscription doesn't quite work
    @MainActor
    func testCreateUpdatesPublisher() async throws {
        store.setup(gardenID: "test")
        try await store.loadGarden()

        let image = UIImage(named: "peas")!
        _ = try await store.createPhoto(image: image)
        let expectation = self.expectation(description: "Store subscription")
        let _ = store.allPhotosPublisher.handleEvents(receiveRequest:  { subscriptions in
            expectation.fulfill()
        })
        await fulfillment(of: [expectation])
        XCTAssertEqual(store.allPhotos.count, 1)
    }
     */

    @MainActor
    func testRelationship() async throws {
        store.setup(gardenID: "test")
        try await store.loadGarden()

        let plant = try await store.createPlant(name: "abc", type: .cucumber, category: .cucurbit)
        let image = UIImage(named: "peas")!
        let photo = try await store.createPhoto(image: image)

        let snap = try await store.createSnap(plant: plant, photo: photo, start: .start, end: .end)
        XCTAssertEqual(store.allSnaps.count, 1)
        XCTAssertEqual(store.snaps(for: photo).first, snap)
        XCTAssertEqual(store.photos(for: plant).first, photo)
        XCTAssertEqual(store.plants(for: photo).first, plant)
    }

    @MainActor
    func testPurge() async throws {
        store.setup(gardenID: "test")
        try await store.loadGarden()
        XCTAssertTrue(store.allPlants.isEmpty)
        XCTAssertTrue(store.allPhotos.isEmpty)
        XCTAssertTrue(store.allSnaps.isEmpty)
    }

    @MainActor
    func testUpdateSnapCoordinates() async throws {

        // update a snap's coordinates
        // make sure the snap is updated when fetched
    }

    @MainActor
    func testUpdateSnapPhoto() async throws {
        // update a snap's photoId
        // make sure the snap is updated when fetched
        // make sure snapsForPlant is updated
        // make sure snapsForPhoto remains unchanged
    }
}
