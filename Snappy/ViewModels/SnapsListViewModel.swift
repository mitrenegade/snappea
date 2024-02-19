//
//  SnapsListViewModel.swift
//  Snappy
//
//  Created by Bobby Ren on 4/26/20.
//  Copyright © 2020 RenderApps LLC. All rights reserved.
//

import Combine
import Foundation

class SnapsListViewModel<T>: ObservableObject where T: Store {
    @Published var snaps: [Snap] = []

    private let belongsToId: String

    private let belongsToType: SnapsCollectionType

    @Published var store: T

    private var cancellables = Set<AnyCancellable>()

    init(for id: String, type: SnapsCollectionType, store: T) {
        self.store = store
        self.belongsToId = id
        self.belongsToType = type

        self.loadSnaps()
    }

    private func loadSnaps() {
        switch belongsToType {
        case .plant:
            snaps = store.allSnaps.filter { $0.plantId == belongsToId }
        case .photo:
            snaps = store.allSnaps.filter { $0.photoId == belongsToId }
        }
    }

    var title: String {
        "SnapsListView: \(belongsToType)"
    }
}
