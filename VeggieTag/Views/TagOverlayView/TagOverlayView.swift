//
//  TagOverlayView.swift
//  VeggieTag
//
//  Created by Bobby Ren on 4/21/20.
//  Copyright © 2020 RenderApps LLC. All rights reserved.
//

import SwiftUI

struct TagOverlayView: View {
    @ObservedObject var viewModel: TagOverlayViewModel

    init(photo: Photo, tags: [Tag]) {
        viewModel = TagOverlayViewModel(photo: photo, tags: tags)
    }
    
    var body: some View {
        ZStack {
            AsyncImageView(url: $viewModel.url.wrappedValue,
                           placeholder: Text("Loading..."), cache: TemporaryImageCache.shared)
                .aspectRatio(contentMode: .fill)
            ForEach(viewModel.tagViews) {tagView in
                tagView
            }
        }
    }
}

struct TagOverlayView_Previews: PreviewProvider {
    static var previews: some View {
        TagOverlayView(photo: APIService.photoData[0], tags: APIService.tagData)
    }
}

