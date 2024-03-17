//
//  LocalStoreTests.swift
//  SnappyTests
//
//  Created by Bobby Ren on 3/16/24.
//  Copyright © 2024 RenderApps LLC. All rights reserved.
//

import XCTest
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
        try await store.loadGarden(id: "test")

        try await store.loadGarden(id: "test")
        XCTAssertFalse(store.isLoading)
        var pathComponents = store.imageBaseURL.pathComponents
        XCTAssert(pathComponents.contains("image"))
        XCTAssert(pathComponents.contains("Documents"))
        XCTAssertEqual(pathComponents.popLast(), "image")
        XCTAssertEqual(pathComponents.popLast(), "test")
    }

    @MainActor
    func testCreatePlant() async throws {
        try await store.loadGarden(id: "test")

        _ = try store.createPlant(name: "abc", type: .cucumber, category: .cucurbit)
        XCTAssertEqual(store.allPlants.count, 1)
    }

    @MainActor
    func testCreatePhoto() async throws {
        try await store.loadGarden(id: "test")

        let image = UIImage(named: "peas")!
        _ = try store.createPhoto(image: image)
        XCTAssertEqual(store.allPhotos.count, 1)
    }

    @MainActor
    func testRelationship() async throws {
        try await store.loadGarden(id: "test")

        let plant = try store.createPlant(name: "abc", type: .cucumber, category: .cucurbit)
        let image = UIImage(named: "peas")!
        let photo = try store.createPhoto(image: image)
        let snap = try await store.createSnap(plant: plant, photo: photo, start: .start, end: .end)
        XCTAssertEqual(store.allSnaps.count, 1)
        XCTAssertEqual(store.photos(for: plant).first, photo)
        XCTAssertEqual(store.snaps(for: photo).first, snap)
        XCTAssertEqual(store.photos(for: plant).first, photo)
        XCTAssertEqual(store.plants(for: photo).first, plant)
    }

    @MainActor
    func testPurge() async throws {
        try await store.loadGarden(id: "test")
        XCTAssertTrue(store.allPlants.isEmpty)
        XCTAssertTrue(store.allPhotos.isEmpty)
        XCTAssertTrue(store.allSnaps.isEmpty)
    }
}
