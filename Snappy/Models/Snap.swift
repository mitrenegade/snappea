//
//  Tag.swift
//  Snappy
//
//  Created by Bobby Ren on 4/19/20.
//  Copyright © 2020 RenderApps LLC. All rights reserved.
//

import FirebaseFirestore
import FirebaseFirestoreSwift

/// An snapshot of a plant at a single instance in time.
struct Snap: Identifiable, Codable {
//    @DocumentID var id: String? = nil
    var id: String? = nil
    var photoId: String = ""
    var plantId: String = ""
    var start: NormalizedCoordinate
    var end: NormalizedCoordinate

    init(photoId: String, start: NormalizedCoordinate, end: NormalizedCoordinate) {
        self.id = UUID().uuidString
        self.photoId = photoId
        self.start = start
        self.end = end
    }
}
