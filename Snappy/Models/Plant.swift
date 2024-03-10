//
//  Plant.swift
//  Snappy
//
//  Created by Bobby Ren on 4/19/20.
//  Copyright © 2020 RenderApps LLC. All rights reserved.
//

enum PlantType: String, Codable, CaseIterable, Identifiable {
    case tomato
    case cucumber
    case lettuce
    case squash
    case unknown

    var id: Self { self }

    init?(rawValue: String) {
        for type in PlantType.allCases {
            if rawValue == type.rawValue {
                self = type
            }
        }
        self = .unknown
    }
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
    var id: String = ""
    var name: String = ""
    var type: PlantType = .unknown
    var category: Category = .other
}
