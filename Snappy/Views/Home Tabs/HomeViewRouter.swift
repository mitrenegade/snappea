//
//  HomeViewRouter.swift
//  Snappy
//
//  Created by Bobby Ren on 5/15/20.
//  Copyright © 2020 RenderApps LLC. All rights reserved.
//

import SwiftUI
import Combine

enum Tab: Hashable {
    case plants
    case gallery
    case camera
}

class HomeViewRouter: ObservableObject {
    private let store: Store

    @Published var isLoading: Bool = true

    @Published var selectedTab: Tab = .plants {
        willSet {
            objectWillChange.send()
        }
    }

    init(store: Store) {
        self.store = store

        Task {
            try await store.loadGarden()
            isLoading = false
        }
    }
}

