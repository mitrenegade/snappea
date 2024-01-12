//
//  GalleryRoot.swift
//  Snappy
//
//  Created by Bobby Ren on 1/11/24.
//  Copyright © 2024 RenderApps LLC. All rights reserved.
//

import SwiftUI
import RenderCloud
import Combine

/// Displays a gallery of photos
struct GalleryRoot: View {
    private let dataStore: DataStore

    private let apiService: APIService

    @ObservedObject var viewModel: GalleryViewModel

    init(router: HomeViewRouter,
         apiService: APIService = FirebaseAPIService.shared,
         dataStore: DataStore = FirebaseDataStore()
    ) {
        viewModel = GalleryViewModel(apiService: apiService, dataStore: dataStore, router: router)
        self.apiService = apiService
        self.dataStore = dataStore
    }

    var body: some View {
        NavigationView{
            Group {
                if TESTING {
                    Text("GalleryRoot")
                } else {
                    Text("Gallery")
                }
                if viewModel.dataSource.count == 0 {
                    Text("Loading...")
                } else {
                    galleryView
                }
            }
            .navigationBarItems(leading: logoutButton)
        }
    }


    private var logoutButton = {
        Button(action: {
            LoginViewModel().signOut()
        }) {
            Text("Logout")
        }
    }()

    private var galleryView: some View {
        // TODO: make this a gallery
        List(viewModel.dataSource) { photo in
            NavigationLink(destination: PhotoDetailView(photo: photo, store: dataStore, apiService: apiService)
            ) {
                PhotoRow(photo: photo)
            }
        }
    }
}
