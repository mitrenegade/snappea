//
//  SnapOverlayView.swift
//  Snappy
//
//  Created by Bobby Ren on 4/21/20.
//  Copyright © 2020 RenderApps LLC. All rights reserved.
//

import SwiftUI

struct SnapOverlayView<T>: View where T: Store {
    @ObservedObject var viewModel: SnapOverlayViewModel<T>

    @EnvironmentObject var imageLoaderFactory: ImageLoaderFactory

    var imageSize: CGSize

    @State var dragging: Bool = false
    @State var draggingStart: CGPoint = CGPoint.zero
    @State var draggingEnd: CGPoint = CGPoint.zero

    init(photo: Photo,
         selectedSnaps: [Snap]? = nil,
         store: T,
         imageSize: CGSize
    ) {
        viewModel = SnapOverlayViewModel(photo: photo, selectedSnaps: selectedSnaps, store: store)
        self.imageSize = imageSize
    }
    
    var body: some View {
        VStack {
            ZStack {
                let imageLoader = imageLoaderFactory.create(imageName: $viewModel.photoId.wrappedValue, cache: TemporaryImageCache.shared)
                let placeholder = Text("Loading...")
                AsyncImageView(imageLoader: imageLoader, frame: imageSize, placeholder: placeholder)
                ForEach(viewModel.snaps) {snap in
                    SnapView(snap: snap, size: imageSize)
                        .frame(width: imageSize.width, height: imageSize.height)
                }
                drawBoxView
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
                        self.createSnap(start: value.startLocation, end: value.location)
                    }
            )
            Spacer()
        }
    }
    
    func createSnap(start: CGPoint, end: CGPoint) {
        viewModel.createSnap(start: start, end: end, imageSize: imageSize)
    }

    var drawBoxView: some View {
        Group {
            if dragging {
                DragView(imageSize: imageSize, start: draggingStart, end: draggingEnd)
            } else {
                EmptyView()
            }
        }
    }
}
