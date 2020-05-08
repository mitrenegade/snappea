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
    var imageWidth: CGFloat
    var imageHeight: CGFloat
    
    private var apiService: APIService

    init(photo: Photo, apiService: APIService = APIService.shared) {
        viewModel = TagOverlayViewModel(photo: photo)
        imageWidth = UIScreen.main.bounds.width
        imageHeight = imageWidth // this can be changed
        
        self.apiService = apiService
    }
    
    var body: some View {
        ZStack {
            AsyncImageView(url: $viewModel.url.wrappedValue,
                           frame: CGSize(width: imageWidth, height: imageHeight),
                           placeholder: Text("Loading..."),
                           cache: TemporaryImageCache.shared)
                .aspectRatio(contentMode: .fill)
            ForEach(viewModel.tags) {tag in
                TagView(tag: tag)
            }
        }.gesture(
            DragGesture(minimumDistance: 0).onEnded{ value in
                print("Tapped: \(value)")
                print("Image frame: \(self.imageWidth) \(self.imageHeight)")
                self.createTag(start: value.startLocation, end: value.location)
            }
        )
    }
    
    func createTag(start: CGPoint, end: CGPoint) {
        // normalize the coordinates to a standard [-1:1] coordinate system
        let normalizedX0: CGFloat = (2 * start.x - imageWidth) / imageWidth
        let normalizedY0: CGFloat = -(2 * start.y - imageHeight) / imageHeight
        var normalizedX1: CGFloat? = (2 * end.x - imageWidth) / imageWidth
        var normalizedY1: CGFloat? = -(2 * end.y - imageHeight) / imageHeight
        if abs((normalizedX1 ?? 0) - normalizedX0) < 0.01 ||
            abs((normalizedY1 ?? 0) - normalizedY0) < 0.01{
            normalizedX1 = nil
            normalizedY1 = nil
        }
        print("Creating tag from (\(normalizedX0), \(normalizedY0)) to (\(String(describing: normalizedX1)), \(String(describing: normalizedY1)))")
        
        guard let photoId = viewModel.photoId else { return }
        let tag = Tag(photoId: photoId, x0: normalizedX0, y0: normalizedY0, x1: normalizedX1, y1: normalizedY1)
        apiService.addTag(tag)
        
        // reload?
        viewModel.tags = viewModel.photo.tags
//        viewModel = TagOverlayViewModel(photo: viewModel.photo)
    }
}

struct TagOverlayView_Previews: PreviewProvider {
    static var previews: some View {
        TagOverlayView(photo: DataHelper.photoData[0])
    }
}

