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
    
    init(router: HomeViewRouter,
         apiService: APIService = APIService.shared) {
        viewModel = PlantsListViewModel(apiService: apiService, router: router)
    }

    var body: some View {
        NavigationView{
            Group {
                if viewModel.dataSource.count == 0 {
                    Text("Loading...")
                } else {
                    listView
                }
                newPhotoView
            }
            .navigationBarItems(leading:
                Button(action: {
                LoginViewModel().signOut()
                }) {
                    Text("Logout")
            })
        }

    }
    
    var listView: some View {
        List(viewModel.dataSource) { plant in
            PlantRow(plant: plant)
//            NavigationLink(destination: PhotoDetailView(photo: photo)) {
//                PlantRow(plant: plant)
//            }
        }
    }
    
    var newPhotoView: some View {
        Group {
            if photoDetailSettings.newPhoto != nil {
                NavigationLink(destination: PhotoDetailView(photo: photoDetailSettings.newPhoto!),
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
