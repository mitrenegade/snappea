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
    @ObservedObject private var loader: ImageLoader

    init(photo: Photo, tags: [Tag]) {
        viewModel = TagOverlayViewModel(photo: photo, tags: tags)

        self.loader = ImageLoader(url: URL(string: photo.url)!)
        loader.load()
    }
    
    var body: some View {
        ZStack {
            image
            ForEach(viewModel.tagViews) {tagView in
                tagView
            }
        }
    }
    
    var image: some View {
        Group {
            if loader.image != nil {
                Image(uiImage: loader.image!)
                    .resizable()
            }
        }
    }
}

struct TagOverlayView_Previews: PreviewProvider {
    static var previews: some View {
        TagOverlayView(photo: photoData[0], tags: tagData)
    }
}

