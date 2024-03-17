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

    private let imageLoaderFactory: ImageLoaderFactory

    init(store: T,
         imageLoaderFactory: ImageLoaderFactory
    ) {
        self.store = store
        self.imageLoaderFactory = imageLoaderFactory
    }

    var body: some View {
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
            NavigationLink(destination: AddPlantView(store: store)) {
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

                NavigationLink(destination: PlantGalleryView(plant: plant, store: store, imageLoaderFactory: imageLoaderFactory)) {
                    PlantRow(viewModel: PlantRowViewModel(plant: plant, photo: photo), imageLoaderFactory: imageLoaderFactory)
                }
            }
        }
    }
}

//struct PlantsRoot_Previews: PreviewProvider {
//    static var previews: some View {
//        PlantsRoot(router: HomeViewRouter(store: MockStore()), store: MockStore())
//    }
//}
