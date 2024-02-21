//
//  HomeViewRouter.swift
//  Snappy
//
//  Created by Bobby Ren on 5/15/20.
//  Copyright © 2020 RenderApps LLC. All rights reserved.
//

import SwiftUI

/// Global state for selected tab
class TabsRouter: ObservableObject {
    @Published var selectedTab: Tab = .plants
}

