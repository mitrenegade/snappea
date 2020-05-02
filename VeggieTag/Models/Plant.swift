//
//  Plant.swift
//  VeggieTag
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
    @DocumentID var id: String?
    var name: String
    var type: PlantType
    var category: Category
    @ServerTimestamp var createdTime: Timestamp?
    
    init?(from snapshot: QueryDocumentSnapshot) {
        guard let name = snapshot["name"] as? String else { return nil }
        guard let type = snapshot["type"] as? String else { return nil }
        guard let category = snapshot["category"] as? String else { return nil }
        
        self.name = name
        self.type = PlantType(rawValue: type) ?? .unknown
        self.category = Category(rawValue: category) ?? .unknown
    }
}
