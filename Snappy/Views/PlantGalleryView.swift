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

    @ObservedObject var store: T

    private let imageLoaderType: any ImageLoader.Type

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
            SnapsListView(plant: plant, store: store, imageLoaderType: imageLoaderType)
        }
        .navigationBarItems(trailing: addSnapButton)
    }

    init(plant: Plant,
         store: T,
         imageLoaderType: any ImageLoader.Type
    ) {
        self.plant = plant
        self.store = store
        self.imageLoaderType = imageLoaderType
    }

    private var addSnapButton: some View {
        Button(action: {
            router.selectedTab = .camera
            photoEnvironment.isAddingPhotoToPlant = true
        }) {
            Image(systemName: "photo.badge.plus")
        }
    }
}
