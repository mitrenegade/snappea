//
//  Plant.swift
//  SnapPea
//
//  Created by Bobby Ren on 4/19/20.
//  Copyright © 2020 RenderApps LLC. All rights reserved.
//

import FirebaseFirestore
import FirebaseFirestoreSwift

enum PlantType: String, Codable {
    case tomato
    case cucumber
    case lettuce
    case unknown
}
enum Category: String, Codable {
    case herb
    case vegetable
    case unknown
}

struct Plant: Identifiable, Codable {
    @DocumentID var id: String? = nil
    var name: String = ""
    var type: PlantType = .unknown
    var category: Category = .unknown
//    @ServerTimestamp var createdTime: Timestamp?
}
