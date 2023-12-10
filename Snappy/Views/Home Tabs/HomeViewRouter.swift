//
//  HomeViewRouter.swift
//  SnapPea
//
//  Created by Bobby Ren on 5/15/20.
//  Copyright © 2020 RenderApps LLC. All rights reserved.
//

import SwiftUI
import Combine

enum Tab: Hashable {
    case photos
    case camera
}

class HomeViewRouter: ObservableObject {
    @Published var selectedTab: Tab = .photos {
        willSet {
            objectWillChange.send()
        }
    }
}

