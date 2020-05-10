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
}
