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
    @Binding var selectedPlant: Plant?

    var body: some View {
        VStack {
            HStack {
                Spacer()
                optionsButton.padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 20))
            }
            List(store.allPlants, selection: $selectedPlant) { plant in
                let photo = store.photos(for: plant)
                    .sorted { $0.timestamp > $1.timestamp }
                    .first
                NavigationLink(value: plant) {
                    PlantRow(viewModel: PlantRowViewModel(plant: plant, photo: photo))
                }
            }
            Spacer()
        }
    }

    private var optionsButton: some View {
        Button {
            showOptions()
        } label: {
            Image(systemName: "ellipsis.circle")
        }

    }

    private func showOptions() {

    }
}
