//
//  PhotoGalleryViewModel.swift
//  Snappy
//
//  Created by Bobby Ren on 1/11/24.
//  Copyright © 2024 RenderApps LLC. All rights reserved.
//

import Foundation

class PhotoGalleryViewModel: ObservableObject, Observable {
    @Published var dataSource: [Photo] = []
    @Published var router: HomeViewRouter

    init(store: Store, router: HomeViewRouter) {
        self.router = router

        Task {
            try await store.loadGarden()
            await updateDataSource(store.allPhotos)
        }
    }

    @MainActor
    private func updateDataSource(_ photos: [Photo]) {
        dataSource = photos
    }
}
