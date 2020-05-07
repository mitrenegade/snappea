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
    var x0: CGFloat
    var y0: CGFloat
    var x1: CGFloat? = nil
    var y1: CGFloat? = nil
    
    var plant: Plant? {
        return APIService.shared.plants.first { $0.id == plantId }
    }
    
    var photo: Photo? {
        return APIService.shared.photos.first { $0.id == photoId }
    }
    
    init(photoId: String, x0: CGFloat, y0: CGFloat, x1: CGFloat? = nil, y1: CGFloat? = nil) {
        self.photoId = photoId
        self.x0 = x0
        self.y0 = y0
        self.x1 = x1
        self.y1 = y1
    }
}
