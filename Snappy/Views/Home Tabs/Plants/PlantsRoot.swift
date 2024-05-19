//
//  PlantsRoot.swift
//  Snappy
//
//  Created by Bobby Ren on 4/19/20.
//  Copyright © 2020 RenderApps LLC. All rights reserved.
//

import SwiftUI
import RenderCloud
import Combine

/// Displays an index of plants
struct PlantsRoot<T>: View where T: Store {
    @ObservedObject var store: T

    /// Displays photo gallery for selecting an image for AddPlantView
    @State var shouldShowPhotoGalleryForAddPlant: Bool = false

    init(store: T) {
        self.store = store
    }

    var body: some View {
        ZStack {
            NavigationView {
                Group {
                    if TESTING {
                        Text("PlantsRoot").font(.title)
                    } else {
                        Text("Plants").font(.title)
                    }
                    Text("Add a new plant to track it throughout its growth by adding snaps. Start by creating a plant.")
                        .padding(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
                    Spacer()
                    if store.isLoading {
                        Text("Loading...")
                    } else {
                        if store.allPlants.isEmpty {
                            Text("No plants! Click to add some")
                        } else {
                            listView
                        }
                    }
                    Spacer()
                }
                .navigationBarItems(leading: logoutButton,
                                    trailing: addPlantButton
                )
            }

            if shouldShowPhotoGalleryForAddPlant {
                galleryOverlayView
            }

        }

    }

    private var logoutButton = {
        Button(action: {
            LoginViewModel().signOut()
        }) {
            Text("Logout")
        }
    }()

    private var addPlantButton: some View {
        Button(action: {
            
        }) {
            let viewModel = AddPlantViewModel(store: store)
            let view = AddPlantView(viewModel: viewModel, shouldShowGallery: $shouldShowPhotoGalleryForAddPlant)
            NavigationLink(destination: view) {
                Image(systemName: "photo.badge.plus")
            }
        }
    }

    var listView: some View {
        List(store.allPlants) { plant in
            Group {
                let photo = store.photos(for: plant)
                    .sorted { $0.timestamp > $1.timestamp }
                    .first

                NavigationLink(destination: PlantGalleryView(plant: plant, store: store)) {
                    PlantRow(viewModel: PlantRowViewModel(plant: plant, photo: photo))
                }
            }
        }
    }

    // Photo gallery
    private var galleryOverlayView: some View {
        NavigationView {
            VStack {
                Text("Photo Gallery")

                PhotoGalleryView(store: store,
                                 shouldShowDetail: false,
                                 shouldShowGallery: $shouldShowPhotoGalleryForAddPlant)
            }
            .background(.white)
            .navigationBarItems(leading: closeGalleryButton)
        }
    }

    private var closeGalleryButton: some View {
        Button(action: {
            shouldShowPhotoGalleryForAddPlant.toggle()
        }) {
            Text("Close")
        }
    }
}

//struct PlantsRoot_Previews: PreviewProvider {
//    static var previews: some View {
//        PlantsRoot(router: HomeViewRouter(store: MockStore()), store: MockStore())
//    }
//}
