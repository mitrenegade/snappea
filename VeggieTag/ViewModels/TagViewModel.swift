//
//  TagViewModel.swift
//  VeggieTag
//
//  Created by Bobby Ren on 4/20/20.
//  Copyright © 2020 RenderApps LLC. All rights reserved.
//

import Combine

class TagViewModel: ObservableObject {
    @Published var tag: Tag
    init(tag: Tag) {
        self.tag = tag
    }
}
