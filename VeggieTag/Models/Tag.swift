//
//  Tag.swift
//  VeggieTag
//
//  Created by Bobby Ren on 4/19/20.
//  Copyright © 2020 RenderApps LLC. All rights reserved.
//

import FirebaseFirestore

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
        return APIService.plantData.first(where: { $0.id == plantId })
    }
    
    var photo: Photo? {
        return APIService.photoData.first(where: { $0.id == photoId })
    }
    
    init?(from snapshot: QueryDocumentSnapshot) {
        guard let x = snapshot["x"] as? CGFloat, let y = snapshot["y"] as? CGFloat else { return nil }
        guard let plantId = snapshot["plantId"] as? String else { return nil }
        guard let photoId = snapshot["photoId"] as? String else { return nil }

        self.id = snapshot.documentID
        self.plantId = plantId
        self.photoId = photoId
        self.x = x
        self.y = y
    }
}
