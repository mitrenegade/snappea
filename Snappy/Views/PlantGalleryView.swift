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

    var body: some View {
        VStack {
            Text(plant.name)
            SnapsListView(plant: plant, store: store)
        }
    }

    init(plant: Plant, store: DataStore = FirebaseDataStore()) {
        self.plant = plant
        self.store = store
    }
}
