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
struct PlantsRoot: View {
    @ObservedObject var viewModel: PlantsListViewModel
    @EnvironmentObject var user: User
    @EnvironmentObject var photoDetailSettings: PhotoDetailSettings
    
    private var cancellables = Set<AnyCancellable>()

    private let store: Store

    init(router: HomeViewRouter,
         store: Store
    ) {
        viewModel = PlantsListViewModel(store: store, router: router)
        self.store = store
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
                if viewModel.isLoading {
                    Text("Loading...")
                } else {
                    if viewModel.dataSource.isEmpty {
                        Text("No plants! Click to add some")
                    } else {
                        listView
                    }
                }
                newPhotoView
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

    private

    var listView: some View {
        List(viewModel.dataSource) { plant in
            NavigationLink(destination: PlantGalleryView(plant: plant, store: store)) {
                PlantRow(viewModel: PlantRowViewModel(plant: plant, store: store))
            }
        }
    }
    
    var newPhotoView: some View {
        Group {
            if let photo = photoDetailSettings.newPhoto {
                NavigationLink(destination: PhotoDetailView(photo: photo, store: store),
                               isActive: $photoDetailSettings.shouldShowNewPhoto) {
                                EmptyView()
                }
            }
        }
    }
}

struct PlantsRoot_Previews: PreviewProvider {
    static var previews: some View {
        PlantsRoot(router: HomeViewRouter(store: MockStore()), store: MockStore())
    }
}
