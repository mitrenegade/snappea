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
    @Published var dataSource: [Tag]

    init(tags: [Tag]) {
        dataSource = tags
    }
    
    convenience init(photo: Photo) {
        // todo: load tags from TagService
        self.init(tags: APIService.tagData.filter{ $0.photoId == photo.id })
    }
}
