//
//  Tag.swift
//  VeggieTag
//
//  Created by Bobby Ren on 4/19/20.
//  Copyright © 2020 RenderApps LLC. All rights reserved.
//

import FirebaseFirestore
import FirebaseFirestoreSwift

protocol Taggable
{
    var x: CGFloat { get }
    var y: CGFloat { get }
    var scale: CGFloat? { get }
}

struct Tag: Identifiable, Codable, Taggable {
    var scale: CGFloat? = 1

    @DocumentID var id: String?
    var photoId: String = ""
    var plantId: String = ""
    var x: CGFloat = 0
    var y: CGFloat = 0
    @ServerTimestamp var createdTime: Timestamp?
    
    var plant: Plant? {
        return APIService.shared.plants.first { $0.id == plantId }

    }
    
    var photo: Photo? {
        return APIService.shared.photos.first { $0.id == photoId }
    }
}
