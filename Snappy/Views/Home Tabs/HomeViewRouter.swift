//
//  HomeViewRouter.swift
//  Snappy
//
//  Created by Bobby Ren on 5/15/20.
//  Copyright © 2020 RenderApps LLC. All rights reserved.
//

import SwiftUI

enum Tab: Hashable {
    case plants
    case gallery
    case camera
}

class HomeViewRouter: ObservableObject {

    @Published var selectedTab: Tab = .plants {
        willSet {
            objectWillChange.send()
        }
    }
}

