//
//  GalleryViewModel.swift
//  Snappy
//
//  Created by Bobby Ren on 1/11/24.
//  Copyright © 2024 RenderApps LLC. All rights reserved.
//

import Foundation

class GalleryViewModel: ObservableObject {
    @Published var dataSource: [Photo] = []
    @Published var router: HomeViewRouter

    init(apiService: APIService, dataStore: DataStore, router: HomeViewRouter) {
        self.router = router

        Task {
            try await apiService.loadGarden()
            await updateDataSource(dataStore.allPhotos)
        }
    }

    @MainActor
    private func updateDataSource(_ photos: [Photo]) {
        dataSource = photos
    }
}
