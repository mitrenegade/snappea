//
//  TagOverlayView.swift
//  SnapPea
//
//  Created by Bobby Ren on 4/21/20.
//  Copyright © 2020 RenderApps LLC. All rights reserved.
//

import SwiftUI

struct TagOverlayView: View {
    @ObservedObject var viewModel: TagOverlayViewModel
    var imageSize: CGSize
    
    private var apiService: APIService

    init(photo: Photo, apiService: APIService = APIService.shared) {
        viewModel = TagOverlayViewModel(photo: photo)
        imageSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width)
        
        self.apiService = apiService
    }
    
    var body: some View {
        ZStack {
            AsyncImageView(url: $viewModel.url.wrappedValue,
                           frame: imageSize,
                           placeholder: Text("Loading..."),
                           cache: TemporaryImageCache.shared)
                .aspectRatio(contentMode: .fill)
            ForEach(viewModel.tags) {tag in
                TagView(tag: tag)
            }
        }.gesture(
            DragGesture(minimumDistance: 0).onEnded{ value in
                print("Tapped: \(value)")
                print("Image frame: \(self.imageSize)")
                self.createTag(start: value.startLocation, end: value.location)
            }
        )
    }
    
    func createTag(start: CGPoint, end: CGPoint) {
        guard let photoId = viewModel.photoId else { return }
        let (startCoord, endCoord) = CoordinateService.getValidCoordinatesFromPixels(imageSize: self.imageSize, start: start, end: end)
        
        let tag = Tag(photoId: photoId, start: startCoord, end: endCoord)
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

