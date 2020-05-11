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
    
    @State var dragging: Bool = false
    @State var draggingStart: CGPoint = CGPoint.zero
    @State var draggingEnd: CGPoint = CGPoint.zero
    
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
            drawBoxView
            ForEach(viewModel.tags) {tag in
                TagView(tag: tag)
            }
        }.gesture(
            DragGesture(minimumDistance: 0)
                .onChanged{ (value) in
                    print("Dragging: \(value.startLocation) to \(value.location)")
                    self.dragging = true
                    self.draggingStart = value.startLocation
                    self.draggingEnd = value.location
                }
                .onEnded{ value in
                    self.dragging = false
                    self.draggingStart = CGPoint.zero
                    self.draggingEnd = CGPoint.zero

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
        
        viewModel.tags.append(tag) // force reload
    }
    
    var drawBoxView: some View {
        Group {
            if dragging {
                TagView(tag: Tag(photoId: "",
                                 start: CoordinateService.pixelToCoord(imageSize: self.imageSize, point: draggingStart),
                                 end: CoordinateService.pixelToCoord(imageSize: self.imageSize, point: draggingEnd)))
            } else {
                EmptyView()
            }
        }
    }
}

struct TagOverlayView_Previews: PreviewProvider {
    static var previews: some View {
        TagOverlayView(photo: DataHelper.photoData[0])
    }
}

