//
//  PlantRow.swift
//  VeggieTag
//
//  Created by Bobby Ren on 4/19/20.
//  Copyright © 2020 RenderApps LLC. All rights reserved.
//

import SwiftUI

struct PlantRow: View {
    var plant: Plant
    
    var body: some View {
        HStack {
            Text(plant.name)
        }
    }
}


struct PlantRow_Previews: PreviewProvider {
    static var previews: some View {
        PlantRow(plant: plantData[0])
    }
}
