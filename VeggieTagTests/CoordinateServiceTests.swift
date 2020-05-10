//
//  CoordinateServiceTests.swift
//  VeggieTagTests
//
//  Created by Bobby Ren on 5/9/20.
//  Copyright © 2020 RenderApps LLC. All rights reserved.
//

import XCTest
@testable import VeggieTag

class CoordinateServiceTests: XCTestCase {
    func testPixelToCoord() {
        let imageSize = CGSize(width: 100, height: 200)
        let point1 = CGPoint(x: 50, y: 50)
        let coord1 = CoordinateService.pixelToCoord(imageSize: imageSize, point: point1)
        XCTAssertTrue(coord1.x == 0.5)
        XCTAssertTrue(coord1.y == 0.25)

        let point2 = CGPoint(x: 0, y: 0)
        let coord2 = CoordinateService.pixelToCoord(imageSize: imageSize, point: point2)
        XCTAssertTrue(coord2.x == 0)
        XCTAssertTrue(coord2.y == 0)

        let point3 = CGPoint(x: 100, y: 100)
        let coord3 = CoordinateService.pixelToCoord(imageSize: imageSize, point: point3)
        XCTAssertTrue(coord3.x == 1)
        XCTAssertTrue(coord3.y == 0.5)
    }

    func testCoordToPixel() {
        let imageSize = CGSize(width: 100, height: 200)
        let coord1 = NormalizedCoordinate(x: 0.5, y: 0.5)
        let point1 = CoordinateService.coordToPixel(imageSize: imageSize, coordinate: coord1)
        XCTAssertTrue(point1.x == 50)
        XCTAssertTrue(point1.y == 100)

        let coord2 = NormalizedCoordinate(x: 0.0, y: 0.0)
        let point2 = CoordinateService.coordToPixel(imageSize: imageSize, coordinate: coord2)
        XCTAssertTrue(point2.x == 0)
        XCTAssertTrue(point2.y == 0)

        let coord3 = NormalizedCoordinate(x: 1, y: 1)
        let point3 = CoordinateService.coordToPixel(imageSize: imageSize, coordinate: coord3)
        XCTAssertTrue(point3.x == 100)
        XCTAssertTrue(point3.y == 200)
    }
    
    func testTap() {
        let imageSize = CGSize(width: 100, height: 100)
        let point1 = CGPoint(x: 50, y: 50)
        let point2: CGPoint? = nil
        let (coord1, coord2) = CoordinateService.getValidCoordinatesFromPixels(imageSize: imageSize, start: point1, end: point2)
        XCTAssertTrue(coord1.x == 0.30)
        XCTAssertTrue(coord1.y == 0.30)
        XCTAssertTrue(coord2.x == 0.70)
        XCTAssertTrue(coord2.y == 0.70)
    }
    
    func testDrag() {
        let imageSize = CGSize(width: 100, height: 100)
        let point1 = CGPoint(x: 30, y: 30)
        let point2: CGPoint? = CGPoint(x: 70, y: 70)
        let (coord1, coord2) = CoordinateService.getValidCoordinatesFromPixels(imageSize: imageSize, start: point1, end: point2)
        XCTAssertTrue(coord1.x == 0.30)
        XCTAssertTrue(coord1.y == 0.30)
        XCTAssertTrue(coord2.x == 0.70)
        XCTAssertTrue(coord2.y == 0.70)
    }
    
    func testBackwardsDrag() {
        let imageSize = CGSize(width: 100, height: 100)
        let point1 = CGPoint(x: 30, y: 70)
        let point2: CGPoint? = CGPoint(x: 70, y: 30)
        let (coord1, coord2) = CoordinateService.getValidCoordinatesFromPixels(imageSize: imageSize, start: point1, end: point2)
        XCTAssertTrue(coord1.x == 0.30)
        XCTAssertTrue(coord1.y == 0.30)
        XCTAssertTrue(coord2.x == 0.70)
        XCTAssertTrue(coord2.y == 0.70)
    }
}
