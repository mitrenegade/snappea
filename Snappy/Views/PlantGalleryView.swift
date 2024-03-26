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

    // add image
    @State private var showingAddImageLayer = false
    @State var image: UIImage? = nil

    // plant editor
    @State var isPhotoEditorPresented = false

    private var title: String {
        if TESTING {
            return "PlantGalleryView: \(plant.name)"
        } else {
            return plant.name
        }
    }

    var body: some View {
        ZStack {
            VStack(spacing: 4) {
                Text(title)
                PlantBasicView(plant: plant, photo:
                                store.photos(for: plant).first)
                SnapsListView(plant: plant, store: store)
            }
            .navigationBarItems(trailing: addSnapButton)

            if showingAddImageLayer {
                AddImageHelperLayer(image: $image, showingSelf: $showingAddImageLayer)
            }

//            if let image {
//                AddPhotoToPlantView(store: store, plant: plant, image: image)
//            }
        }
        .onChange(of: image) {
            showingAddImageLayer = false
            if image != nil {
                isPhotoEditorPresented = true
            }
        }
    }

    init(plant: Plant,
         store: T
    ) {
        self.plant = plant
        self.store = store
    }

    private var addSnapButton: some View {
        Button(action: {
            self.showingAddImageLayer = true
        }) {
            Image(systemName: "photo.badge.plus")
        }
    }

    private func dismissEditor() {
        // no op
    }

}
