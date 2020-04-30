//
//  TagsView.swift
//  VeggieTag
//
//  Created by Bobby Ren on 4/19/20.
//  Copyright © 2020 RenderApps LLC. All rights reserved.
//

import SwiftUI

struct TagsListView: View {
    var viewModel: TagsListViewModel
    var body: some View {
        List(viewModel.dataSource) { tag in
            TagRow(tag: tag)
        }
    }
    
    init(tags: [Tag]) {
        self.viewModel = TagsListViewModel(tags: tags)
    }
    
    // convenience
    init(photo: Photo) {
        self.viewModel = TagsListViewModel(photo: photo)
    }
}

struct TagsListView_Previews: PreviewProvider {
    static var previews: some View {
        TagsListView(photo: APIService.photoData[0])
    }
}
