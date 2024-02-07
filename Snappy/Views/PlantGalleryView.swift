//
//  PlantGalleryView.swift
//  Snappy
//
//  Created by Bobby Ren on 12/30/23.
//  Copyright © 2023 RenderApps LLC. All rights reserved.
//

import SwiftUI
import Combine

/// Shows a gallery of all photos for a single plant in list format
struct PlantGalleryView: View {
    private let plant: Plant
    private let store: Store

    private var title: String {
        if TESTING {
            return "PlantGalleryView: \(plant.name)"
        } else {
            return plant.name
        }
    }

    var body: some View {
        VStack {
            Text(title)
            SnapsListView(plant: plant, store: store)
        }
    }

    init(plant: Plant, store: Store) {
        self.plant = plant
        self.store = store
    }
}
