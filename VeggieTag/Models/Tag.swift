//
//  Tag.swift
//  VeggieTag
//
//  Created by Bobby Ren on 4/19/20.
//  Copyright © 2020 RenderApps LLC. All rights reserved.
//

import SwiftUI

protocol Taggable
{
    var x: CGFloat { get }
    var y: CGFloat { get }
    var scale: CGFloat? { get }
}

struct Tag: Identifiable, Hashable, Codable, Taggable {
    var scale: CGFloat? = 1

    var id: String
    var photoId: String
    var plantId: String
    var x: CGFloat
    var y: CGFloat
    
    var plant: Plant? {
        return DataSample.plantData.first(where: { $0.id == plantId })
    }
    
    var photo: Photo? {
        return DataSample.photoData.first(where: { $0.id == photoId })
    }
}
