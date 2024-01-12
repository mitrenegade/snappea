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

    private let dataStore: DataStore

    init(router: HomeViewRouter,
         apiService: APIService = FirebaseAPIService.shared,
         dataStore: DataStore = FirebaseDataStore()
    ) {
        viewModel = PlantsListViewModel(apiService: apiService, dataStore: dataStore, router: router)
        self.dataStore = dataStore
    }

    var body: some View {
        NavigationView{
            Group {
                if TESTING {
                    Text("PlantsRoot")
                }
                if viewModel.dataSource.count == 0 {
                    Text("Loading...")
                } else {
                    listView
                }
                newPhotoView
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

    private var addPlantButton = {
        Button(action: {
            
        }) {
            NavigationLink(destination: AddPlantView()) {
                Image(systemName: "photo.badge.plus")
            }
        }
    }()

    private

    var listView: some View {
        List(viewModel.dataSource) { plant in
            NavigationLink(destination: PlantGalleryView(plant: plant, store: dataStore)) {
                PlantRow(viewModel: PlantRowViewModel(plant: plant, dataStore: dataStore))
            }
        }
    }
    
    var newPhotoView: some View {
        Group {
            if let photo = photoDetailSettings.newPhoto {
                NavigationLink(destination: PhotoDetailView(photo: photo),
                               isActive: $photoDetailSettings.shouldShowNewPhoto) {
                                EmptyView()
                }
            }
        }
    }
}

struct PlantsRoot_Previews: PreviewProvider {
    static var previews: some View {
        PlantsRoot(router: HomeViewRouter())
    }
}
