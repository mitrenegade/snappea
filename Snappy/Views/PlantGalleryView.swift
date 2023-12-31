//
//  PlantGalleryView.swift
//  Snappy
//
//  Created by Bobby Ren on 12/30/23.
//  Copyright © 2023 RenderApps LLC. All rights reserved.
//

import SwiftUI
import Combine

struct PlantGalleryView: View {
    private let plant: Plant

    var body: some View {
        VStack {
            Text(plant.name)
            SnapsListView(plant: plant)
        }
    }

    init(plant: Plant) {
        self.plant = plant
    }
}
