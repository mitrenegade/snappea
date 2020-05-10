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
    
    func testTapAtCenter() {
        let tag = Tag(photoId: "", x0: 0, y0: 0, x1: nil, y1: nil)
        let viewModel = TagViewModel(tag: tag, imageWidth: 100, imageHeight: 100)

        let x0 = viewModel.getX0()
        XCTAssert(x0 == 30, "Calculated x0 \(x0)")
        
        let y0 = viewModel.getY0()
        XCTAssert(y0 == 30, "Calculated y0 \(y0)")

        let width = viewModel.getWidth()
        XCTAssert(width == 40, "Calculated width \(width)")
        
        let height = viewModel.getHeight()
        XCTAssert(height == 40, "Calculated height \(height)")
    }
}
