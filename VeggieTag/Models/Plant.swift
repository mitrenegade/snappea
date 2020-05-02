//
//  Plant.swift
//  VeggieTag
//
//  Created by Bobby Ren on 4/19/20.
//  Copyright © 2020 RenderApps LLC. All rights reserved.
//

import FirebaseFirestore

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

struct Plant: Identifiable, Hashable, Codable {

    var id: String
    var name: String
    var type: PlantType
    var category: Category
    
    init(from snapshot: QueryDocumentSnapshot) {
        self.id = snapshot.documentID
        self.name = snapshot["name"] as? String ?? ""
        if let type = snapshot["type"] as? String {
            self.type = PlantType(rawValue: type) ?? .unknown
        } else {
            self.type = .unknown
        }
        if let category = snapshot["category"] as? String {
            self.category = Category(rawValue: category) ?? .unknown
        } else {
            self.category = .unknown
        }
    }
}
