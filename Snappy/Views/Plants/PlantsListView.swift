//
//  PlantsListView.swift
//  Snappy
//
//  Created by Bobby Ren on 5/23/24.
//  Copyright © 2024 RenderApps LLC. All rights reserved.
//

import Foundation
import SwiftUI

struct PlantsListView<T>: View where T: Store {
    @ObservedObject var store: T

    var body: some View {
        List(store.allPlants) { plant in
            let photo = store.photos(for: plant)
                .sorted { $0.timestamp > $1.timestamp }
                .first
            NavigationLink(value: plant) {
                PlantRow(viewModel: PlantRowViewModel(plant: plant, photo: photo))
            }
        }
        .navigationDestination(for: Plant.self) { plant in
            PlantGalleryView(plant: plant, store: store)
        }
    }
}
