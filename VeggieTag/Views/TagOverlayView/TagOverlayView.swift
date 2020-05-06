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
    var screenWidth: CGFloat

    init(photo: Photo, tags: [Tag]) {
        viewModel = TagOverlayViewModel(photo: photo)
        screenWidth = UIScreen.main.bounds.width
    }
    
    var body: some View {
        ZStack {
            AsyncImageView(url: $viewModel.url.wrappedValue,
                           frame: CGSize(width: screenWidth, height: screenWidth),
                           placeholder: Text("Loading..."),
                           cache: TemporaryImageCache.shared)
                .aspectRatio(contentMode: .fill)
            ForEach(viewModel.tags) {tag in
                TagView(tag: tag)
            }
        }.gesture(
            DragGesture(minimumDistance: 0).onEnded{ value in
                print("Tapped: \(value)")
                print("Loaded image: \(TemporaryImageCache.shared[self.viewModel.url])")
                print("Image frame: \(screenWidth)")
            }
        )
    }
}

struct TagOverlayView_Previews: PreviewProvider {
    static var previews: some View {
        TagOverlayView(photo: DataHelper.photoData[0], tags: DataHelper.tagData)
    }
}

