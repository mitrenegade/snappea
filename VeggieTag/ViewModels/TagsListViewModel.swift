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
        self.init(tags: APIService.shared.allTags.filter{ $0.value.photoId == photo.id }.compactMap{ $0.value })
    }
}
