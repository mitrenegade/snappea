//
//  Tag.swift
//  VeggieTag
//
//  Created by Bobby Ren on 4/19/20.
//  Copyright © 2020 RenderApps LLC. All rights reserved.
//

import SwiftUI

struct Tag: Identifiable, Hashable, Codable {

    var id: String
    var photoId: String
    var plantId: String
    var timestamp: Int
    var x: Int
    var y: Int
}
