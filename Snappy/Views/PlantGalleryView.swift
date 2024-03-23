//
//  PlantGalleryView.swift
//  Snappy
//
//  Created by Bobby Ren on 12/30/23.
//  Copyright © 2023 RenderApps LLC. All rights reserved.
//

import SwiftUI
import Combine

protocol PlantGalleryDelegate {
    func goToAddPhoto()
}

/// Shows a gallery of all photos for a single plant in list format
struct PlantGalleryView<T>: View where T: Store {
    private let plant: Plant

    @EnvironmentObject var photoEnvironment: PhotoEnvironment
    @EnvironmentObject var router: TabsRouter
    @EnvironmentObject var imageLoaderFactory: ImageLoaderFactory

    @ObservedObject var store: T

    private var title: String {
        if TESTING {
            return "PlantGalleryView: \(plant.name)"
        } else {
            return plant.name
        }
    }

    var body: some View {
        VStack(spacing: 4) {
            Text(title)
            PlantBasicView(plant: plant, photo:
                            store.photos(for: plant).first)
            SnapsListView(plant: plant, store: store)
        }
        .navigationBarItems(trailing: addSnapButton)
    }

    init(plant: Plant,
         store: T
    ) {
        self.plant = plant
        self.store = store
    }

    private var addSnapButton: some View {
        Button(action: {
            // no op
        }) {
            NavigationLink(destination: AddPhotoToPlantView(store: store, plant: plant)) {
                Image(systemName: "photo.badge.plus")
            }
        }
    }

}
