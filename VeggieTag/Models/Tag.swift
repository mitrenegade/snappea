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
    var x: Int
    var y: Int
    
    var plant: Plant? {
        return plantData.first(where: { $0.id == plantId })
    }
    
    var photo: Photo? {
        return photoData.first(where: { $0.id == photoId })
    }
}
