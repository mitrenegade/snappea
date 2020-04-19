//
//  Plant.swift
//  VeggieTag
//
//  Created by Bobby Ren on 4/19/20.
//  Copyright © 2020 RenderApps LLC. All rights reserved.
//

import UIKit

enum Type {
    
}
struct Plant: Codable {
    enum PlantType: String, Codable {
        case tomato
        case cucumber
    }
    enum Category: String, Codable {
        case herb
        case vegetable
    }
    var name: String
    var type: PlantType
}
