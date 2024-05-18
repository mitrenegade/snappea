//
//  NormalizedCoordinate.swift
//  Snappy
//
//  Created by Bobby Ren on 5/10/20.
//  Copyright © 2020 RenderApps LLC. All rights reserved.
//

import UIKit

/// A coordinate system normalized from 0 1 to
struct NormalizedCoordinate: Codable, Equatable {
    var x: Double
    var y: Double
}

extension NormalizedCoordinate {
    static let start = NormalizedCoordinate(x: 0, y: 0)
    static let end = NormalizedCoordinate(x: 1, y: 1)
}
