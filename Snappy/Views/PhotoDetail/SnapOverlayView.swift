//
//  SnapOverlayView.swift
//  Snappy
//
//  Created by Bobby Ren on 4/21/20.
//  Copyright © 2020 RenderApps LLC. All rights reserved.
//

import SwiftUI

// BR TODO rename this to SnapsOverlayView
// and remove drag gesture
struct SnapOverlayView<T>: View where T: Store {
    @ObservedObject var viewModel: SnapOverlayViewModel<T>

    @EnvironmentObject var imageLoaderFactory: ImageLoaderFactory
    @EnvironmentObject var overlayEnvironment: OverlayEnvironment

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
//                let imageLoader = imageLoaderFactory.create(imageName: $viewModel.photoId.wrappedValue, cache: TemporaryImageCache.shared)
                let placeholder = Text("Loading...")
                let imageLoader = FirebaseImageLoader()
                AsyncImageView(imageLoader: imageLoader, frame: imageSize, placeholder: placeholder)
                    .onAppear {
                        imageLoader.load(imageName: $viewModel.photoId.wrappedValue)
                    }
                ForEach(viewModel.snaps) {snap in
                    SnapView(snap: snap, size: imageSize)
                        .frame(width: imageSize.width, height: imageSize.height)
                }
                if overlayEnvironment.isEditingSnap {
                    drawBoxView
                }
            }.gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged{ (value) in
                        if overlayEnvironment.isEditingSnap {
                            print("Dragging: \(value.startLocation) to \(value.location)")
                        }
                        self.dragging = true
                        self.draggingStart = value.startLocation
                        self.draggingEnd = value.location
                    }
                    .onEnded{ value in
                        self.dragging = false
                        self.draggingStart = CGPoint.zero
                        self.draggingEnd = CGPoint.zero

                        if overlayEnvironment.isEditingSnap {
                            print("Tapped: \(value)")
                            self.createSnap(start: value.startLocation, end: value.location)
                        }
                    }
            )
            .frame(width: imageSize.width, height: imageSize.height)
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
        .frame(width: imageSize.width, height: imageSize.height)
    }
}
