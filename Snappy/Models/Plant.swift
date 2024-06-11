//
//  Plant.swift
//  Snappy
//
//  Created by Bobby Ren on 4/19/20.
//  Copyright © 2020 RenderApps LLC. All rights reserved.
//

enum PlantType: String, Codable, CaseIterable, Identifiable, Comparable {
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

    static func < (lhs: PlantType, rhs: PlantType) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
}
enum Category: String, Codable, CaseIterable, Identifiable, Comparable {
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

    static func < (lhs: Category, rhs: Category) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
}

struct Plant: Identifiable, Codable, Hashable {
    let id: String
    let name: String
    let type: PlantType
    let category: Category
}
