//
//  NormalizedCoordinate.swift
//  Snappy
//
//  Created by Bobby Ren on 5/10/20.
//  Copyright © 2020 RenderApps LLC. All rights reserved.
//

import UIKit

struct NormalizedCoordinate: Codable {
    var x: Double
    var y: Double
}

extension NormalizedCoordinate {
    static let start = NormalizedCoordinate(x: -1, y: -1)
    static let end = NormalizedCoordinate(x: 1, y: 1)
}
