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
    @EnvironmentObject var photoEnvironment: PhotoEnvironment

    @ObservedObject var store: T
    @ObservedObject var router = Router()
    @State var selectedPlant: Plant? = nil

    /// Displays photo gallery for selecting an image for AddPlantView
    @State var shouldShowPhotoGalleryForAddPlant: Bool = false

    init(store: T) {
        self.store = store
    }

    var body: some View {
        ZStack {
            NavigationStack(path: $router.path) {
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
                .navigationDestination(for: Router.Destination.self) { destination in
                    switch destination {
                    case .addImageToPlant(let image, let plant):
                        AddSnapToPlantView(store: store, plant: plant, image: image) {
                            DispatchQueue.main.async {
                                router.navigateHome()
                            }
                        }
                    case .selectPlantForImage:
                        // no op; PlantsRoot can't take an image yet
                        EmptyView()
                    case .plantGallery(let plant):
                        PlantGalleryView(plant: plant, store: store)
                    case .addPlant:
                        // no way to add a plant with an existing image
                        let viewModel = AddPlantViewModel(store: store)
                        AddPlantView(viewModel: viewModel, image: nil)
                    }
                }

            }
            .environmentObject(router)
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
        Button {
            router.navigate(to: .addPlant(image: nil))
        } label: {
            Image(systemName: "plus.viewfinder")
        }

//        let viewModel = AddPlantViewModel(store: store)
//        let view = AddPlantView(viewModel: viewModel)
//        return NavigationLink(destination: view) {
//            Image(systemName: "photo.badge.plus")
//        }
    }

    var listView: some View {
        let viewModel = PlantsListViewModel(store: store)
        return PlantsListView(selectedPlant: $selectedPlant, viewModel: viewModel)
            .onReceive(selectedPlant.publisher, perform: { value in
                // this must be done to clear the selected route
                // even though this is triggered twice
                // without it, onChange doesn't trigger if the user
                // clicks on the same row
                selectedPlant = nil
            })
            .onChange(of: selectedPlant) { oldValue, newValue in
                if let newValue {
                    router.navigate(to: .plantGallery(newValue))
                }
            }
    }
}

//struct PlantsRoot_Previews: PreviewProvider {
//    static var previews: some View {
//        PlantsRoot(router: HomeViewRouter(store: MockStore()), store: MockStore())
//    }
//}
