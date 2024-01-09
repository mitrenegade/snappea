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
    private let store: DataStore

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

    init(plant: Plant, store: DataStore = FirebaseDataStore()) {
        self.plant = plant
        self.store = store
    }
}
