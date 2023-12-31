//
//  SnapsListViewModel.swift
//  Snappy
//
//  Created by Bobby Ren on 4/26/20.
//  Copyright © 2020 RenderApps LLC. All rights reserved.
//

import Combine
import Foundation

class SnapsListViewModel: ObservableObject {
    @Published var snaps: [Snap] = []

    private let store: DataStore

    private var cancellables = Set<AnyCancellable>()

    init(photo: Photo, store: DataStore = FirebaseDataStore()) {
        self.store = store
        self.loadSnaps(photoId: photo.id)
    }

    init(plant: Plant, store: DataStore = FirebaseDataStore()) {
        self.store = store
        self.loadSnaps(plantId: plant.id)
    }

    private func loadSnaps(plantId: String) {
        snaps = store.allSnaps.filter { $0.plantId == plantId }
    }

    private func loadSnaps(photoId: String) {
        //        $photo.compactMap{ $0?.snaps }
        //            .assign(to: \.dataSource, on: self)
        //            .store(in: &cancellables)
        snaps = store.allSnaps.filter { $0.photoId == photoId }
    }
}
