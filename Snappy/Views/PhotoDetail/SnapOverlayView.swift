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
    var imageSize: CGSize
    
    @State var dragging: Bool = false
    @State var draggingStart: CGPoint = CGPoint.zero
    @State var draggingEnd: CGPoint = CGPoint.zero

    private let imageLoaderType: any ImageLoader.Type

    init(photo: Photo,
         selectedSnaps: [Snap]? = nil,
         store: T,
         imageLoaderType: any ImageLoader.Type
    ) {

        viewModel = SnapOverlayViewModel(photo: photo, selectedSnaps: selectedSnaps, store: store)
        imageSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width)
        self.imageLoaderType = imageLoaderType
    }
    
    var body: some View {
        ZStack {
            if AIRPLANE_MODE {
                Image("peas")
                    .resizable()
                    .frame(width: imageSize.width, height: imageSize.height)
                    .aspectRatio(contentMode: .fit)
                    .clipped()
            } else {
                let imageLoader = imageLoaderType.init(url: $viewModel.url.wrappedValue, cache: TemporaryImageCache.shared)
                let placeholder = Text("Loading...")
                AsyncImageView(imageLoader: imageLoader, frame: imageSize, placeholder: placeholder)
                    .aspectRatio(contentMode: .fill)
            }
            drawBoxView
            ForEach(viewModel.snaps) {snap in
                SnapView(snap: snap)
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
                    self.createSnap(start: value.startLocation, end: value.location)
                }
        )
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
