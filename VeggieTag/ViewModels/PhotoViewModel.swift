//
//  PhotoViewModel.swift
//  VeggieTag
//
//  Created by Bobby Ren on 4/20/20.
//  Copyright © 2020 RenderApps LLC. All rights reserved.
//

import Combine

class PhotoViewModel: ObservableObject {
    @Published var tagViewModels = [TagViewModel]()
    var tags: [Tag] {
        didSet {
            tagViewModels = tags.map{TagViewModel(tag: $0)}
        }
    }
    private var cancellables = Set<AnyCancellable>()
    
    init(tags: [Tag]) {
        self.tags = tags
    }
}
