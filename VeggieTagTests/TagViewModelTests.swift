//
//  TagViewModelTests.swift
//  VeggieTagTests
//
//  Created by Bobby Ren on 5/9/20.
//  Copyright © 2020 RenderApps LLC. All rights reserved.
//

import XCTest
@testable import VeggieTag

class TagViewModelTests: XCTestCase {
    func testIsTap() {
        let tag = Tag(photoId: "", x0: 0, y0: 0, x1: nil, y1: nil)
        let viewModel = TagViewModel(tag: tag, imageWidth: 100, imageHeight: 100)
        
        XCTAssert(viewModel.isTap)
    }
    
    func testTapAtOrigin() {
        let tag = Tag(photoId: "", x0: 0, y0: 0, x1: nil, y1: nil)
        let viewModel = TagViewModel(tag: tag, imageWidth: 100, imageHeight: 100)

        let x0 = viewModel.getX0()
        XCTAssert(x0 == -20, "Calculated x0 \(x0)")
        
        let y0 = viewModel.getY0()
        XCTAssert(y0 == -20, "Calculated y0 \(y0)")

        let width = viewModel.getWidth()
        XCTAssert(width == 40, "Calculated width \(width)")
        
        let height = viewModel.getHeight()
        XCTAssert(height == 40, "Calculated height \(height)")
    }
    
    func testTapAtMax() {
        let tag = Tag(photoId: "", x0: 0, y0: 0, x1: nil, y1: nil)
        let viewModel = TagViewModel(tag: tag, imageWidth: 100, imageHeight: 100)

        let x0 = viewModel.getX0()
        XCTAssert(x0 == 80, "Calculated x0 \(x0)")
        
        let y0 = viewModel.getY0()
        XCTAssert(y0 == 80, "Calculated y0 \(y0)")

        let width = viewModel.getWidth()
        XCTAssert(width == 40, "Calculated width \(width)")
        
        let height = viewModel.getHeight()
        XCTAssert(height == 40, "Calculated height \(height)")
    }
    
    func testDragAtOrigin() {
        let tag = Tag(photoId: "", x0: 0, y0: 0, x1: 0.1, y1: 0.2)
        let viewModel = TagViewModel(tag: tag, imageWidth: 100, imageHeight: 100)

        let x0 = viewModel.getX0()
        XCTAssert(x0 == 0, "Calculated x0 \(x0)")
        
        let y0 = viewModel.getY0()
        XCTAssert(y0 == 0, "Calculated y0 \(y0)")

        let width = viewModel.getWidth()
        XCTAssert(width == 10, "Calculated width \(width)")
        
        let height = viewModel.getHeight()
        XCTAssert(height == 20, "Calculated height \(height)")
    }
    
    func testDragAtMax() {
        let tag = Tag(photoId: "", x0: 0.75, y0: 0.85, x1: 1, y1: 0.95)
        let viewModel = TagViewModel(tag: tag, imageWidth: 100, imageHeight: 100)

        let x0 = viewModel.getX0()
        XCTAssert(x0 == 75, "Calculated x0 \(x0)")
        
        let y0 = viewModel.getY0()
        XCTAssert(y0 == 85, "Calculated y0 \(y0)")

        let width = viewModel.getWidth()
        XCTAssert(width == 25, "Calculated width \(width)")
        
        let height = viewModel.getHeight()
        XCTAssert(height == 10, "Calculated height \(height)")
    }
    
    func testNegativeDrag() {
        let tag = Tag(photoId: "", x0: 0.5, y0: 0.5, x1: 0.4, y1: 0.4)
        let viewModel = TagViewModel(tag: tag, imageWidth: 100, imageHeight: 100)

        let x0 = viewModel.getX0()
        XCTAssert(x0 == 50, "Calculated x0 \(x0)")
        
        let y0 = viewModel.getY0()
        XCTAssert(y0 == 50, "Calculated y0 \(y0)")

        let width = viewModel.getWidth()
        XCTAssert(width == -10, "Calculated width \(width)")
        
        let height = viewModel.getHeight()
        XCTAssert(height == -10, "Calculated height \(height)")
    }
}
