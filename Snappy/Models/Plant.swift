//
//  Plant.swift
//  Snappy
//
//  Created by Bobby Ren on 4/19/20.
//  Copyright © 2020 RenderApps LLC. All rights reserved.
//

import FirebaseFirestore
import FirebaseFirestoreSwift

enum PlantType: String, Codable, CaseIterable, Identifiable {
    case tomato
    case cucumber
    case lettuce
    case unknown

    var id: Self { self }
}
enum Category: String, Codable, CaseIterable, Identifiable {
    case nightshade
    case brassica
    case cucurbit
    case legume
    case allium
    case herb
    case umbellifers
    case leafy
    case other
    case root

    var id: Self { self }
}

struct Plant: Identifiable, Codable, Hashable {
//    @DocumentID var id: String? = nil
    var id: String = ""
    var name: String = ""
    var type: PlantType = .unknown
    var category: Category = .other
//    @ServerTimestamp var createdTime: Timestamp?
}
