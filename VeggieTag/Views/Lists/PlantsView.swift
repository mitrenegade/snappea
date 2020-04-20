//
//  PlantsView.swift
//  VeggieTag
//
//  Created by Bobby Ren on 4/19/20.
//  Copyright © 2020 RenderApps LLC. All rights reserved.
//

import SwiftUI

struct PlantsView: View {
    var plants: [Plant] = []
    var body: some View {
        List(plants) { plant in
            PlantRow(plant: plant)
        }
    }
}

struct PlantsView_Previews: PreviewProvider {
    static var previews: some View {
        PlantsView(plants: plantData)
    }
}
