//
//  TagsListViewModel.swift
//  SnapPea
//
//  Created by Bobby Ren on 4/26/20.
//  Copyright © 2020 RenderApps LLC. All rights reserved.
//

import Combine
import Foundation

class TagsListViewModel: ObservableObject {
    @Published var dataSource: [Tag] = []
    private var cancellables = Set<AnyCancellable>()

    init(tags: [Tag]) {
        dataSource = tags
    }
}
