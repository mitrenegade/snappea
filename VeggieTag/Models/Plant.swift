//
//  Plant.swift
//  VeggieTag
//
//  Created by Bobby Ren on 4/19/20.
//  Copyright © 2020 RenderApps LLC. All rights reserved.
//

import SwiftUI

enum PlantType: String, Codable {
    case tomato
    case cucumber
}
enum Category: String, Codable {
    case herb
    case vegetable
}

struct Plant: Identifiable, Hashable, Codable {

//    var id: ObjectIdentifier
    var id: String
    var name: String
    var type: PlantType
    var category: Category
}
