//
//  Tag.swift
//  VeggieTag
//
//  Created by Bobby Ren on 4/19/20.
//  Copyright © 2020 RenderApps LLC. All rights reserved.
//

import FirebaseFirestore
import FirebaseFirestoreSwift

struct Tag: Identifiable, Codable {
    @DocumentID var id: String? = nil
    var photoId: String = ""
    var plantId: String = ""
    var start: NormalizedCoordinate
    var end: NormalizedCoordinate? = nil
    
    var plant: Plant? {
        return APIService.shared.plants.first { $0.id == plantId }
    }
    
    var photo: Photo? {
        return APIService.shared.photos.first { $0.id == photoId }
    }
    
    init(photoId: String, start: NormalizedCoordinate, end: NormalizedCoordinate) {
        self.photoId = photoId
        self.start = start
        self.end = end
    }
}
