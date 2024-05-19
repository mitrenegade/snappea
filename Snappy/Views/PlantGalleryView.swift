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
    @EnvironmentObject var photoEnvironment: PhotoEnvironment

    private let plant: Plant

    @ObservedObject var store: T

    // add image
    @State private var showingAddImageLayer = false
    @State var newImage: UIImage? = nil

    // plant editor
    @State var isPhotoEditorPresented = false

    // show gallery of existing snaps - not used from this view
    @State private var shouldShowGallery: Bool = false

    // reference to navigation stack's path
    @Binding var path: NavigationPath

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
                //                if let newImage {
                //                    // TODO: should use a NavigationLink to display AddPhotoToPlantView directly
                //                    SnapsListView(plant: plant, store: store, newImage: newImage)
                //                } else {
                SnapsListView(plant: plant, store: store)
                //                }
            }
            .navigationBarItems(trailing: addSnapButton)
            .onChange(of: newImage) { oldValue, newValue in
                if newValue != nil {
                    photoEnvironment.newImage = newImage
                    path.append(plant)
                }
            }
            
            if showingAddImageLayer {
                AddImageHelperLayer(image: $newImage, showingSelf: $showingAddImageLayer, shouldShowGallery: $shouldShowGallery)
            }
        }
    }

    init(plant: Plant,
         store: T,
         navigationPath: Binding<NavigationPath>
    ) {
        self.plant = plant
        self.store = store
        _path = navigationPath
    }

    private var addSnapButton: some View {
        Button(action: {
            print("BRDEBUG PlantGalleryView: add image")
            self.showingAddImageLayer = true
        }) {
            Image(systemName: "photo.badge.plus")
        }
    }

    private func dismissEditor() {
        // no op
        print("Dismissed")
    }

}
