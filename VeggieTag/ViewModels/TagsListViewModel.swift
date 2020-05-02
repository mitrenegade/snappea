//
//  TagsListViewModel.swift
//  VeggieTag
//
//  Created by Bobby Ren on 4/26/20.
//  Copyright © 2020 RenderApps LLC. All rights reserved.
//

import Combine
import Foundation

class TagsListViewModel: ObservableObject {
    @Published var dataSource: [Tag]?
    private var cancellables = Set<AnyCancellable>()

    init(tags: [Tag]) {
        APIService.shared.$tags
            .assign(to: \.dataSource, on: self)
            .store(in: &cancellables)
    }
    
//    convenience init(photo: Photo) {
//        self.init(tags: APIService.shared.allTags.filter{ $0.value.photoId == photo.id }.compactMap{ $0.value })
//    }
}
