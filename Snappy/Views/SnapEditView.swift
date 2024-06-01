//
//  SnapEditView.swift
//  Snappy
//
//  Created by Bobby Ren on 5/20/24.
//  Copyright © 2024 RenderApps LLC. All rights reserved.
//

import Foundation
import SwiftUI

/// Displays either an interface for editing an existing snap and photo, or creating a new snap and photo
struct SnapEditView<T>: View where T: Store {

    @EnvironmentObject var imageLoaderFactory: ImageLoaderFactory
    @EnvironmentObject var overlayEnvironment: OverlayEnvironment

    private let store: T

    private let imageSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width)
//    var imageSize: CGSize

    // MARK: - Editing
    @State private var photo: Photo?
    @State private var snap: Snap?

    // MARK: - Creating
    private var plant: Plant?
    private let image: UIImage?

    // MARK: Gesture
    @Binding var coordinatesChanged: Bool
    @Binding var draggingStart: CGPoint
    @Binding var draggingEnd: CGPoint

    /// Creates an interface to edit an existing snap on an existing photo
    init(snap: Snap,
         store: T,
         coordinatesChanged: Binding<Bool>,
         start: Binding<CGPoint>,
         end: Binding<CGPoint>
    ) {
        self.photo = store.photo(withId: snap.photoId)
        self.snap = snap
        self.store = store

        _coordinatesChanged = coordinatesChanged
        _draggingStart = start
        _draggingEnd = end

        self.image = nil
    }

    /// Creates an interface to create a new snap on a new image
    init(plant: Plant,
         image: UIImage,
         store: T,
         coordinatesChanged: Binding<Bool>,
         start: Binding<CGPoint>,
         end: Binding<CGPoint>
    ) {
        self.plant = plant
        self.image = image
        self.store = store

        self.photo = nil
        self.snap = nil

        _coordinatesChanged = coordinatesChanged
        _draggingStart = start
        _draggingEnd = end
    }

    var body: some View {
        VStack {
            ZStack {
                if let photo {
                    photoSection(id: photo.id)
                } else if let image {
                    imageSection(image: image)
                }

                if let snap, !coordinatesChanged {
                    SnapView(snap: snap, size: imageSize)
                        .frame(width: imageSize.width, height: imageSize.height)
                }
                drawBoxView
            }.gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged{ (value) in
                        self.coordinatesChanged = true
                        self.draggingStart = value.startLocation
                        self.draggingEnd = value.location
                    }
                    .onEnded{ value in
                        print("Drag completed: \(value.startLocation) - \(value.location)")
                    }
            )
            .frame(width: imageSize.width, height: imageSize.height)
            resetButton
        }
    }

    private func photoSection(id: String) -> some View {
//        let imageLoader = imageLoaderFactory.create(imageName: id, cache: TemporaryImageCache.shared)
        let placeholder = Text("Loading...")
        let imageLoader = FirebaseImageLoader(imageName: id, baseUrl: nil, cache: TemporaryImageCache.shared)
        return AsyncImageView(imageLoader: imageLoader, frame: imageSize, placeholder: placeholder)
            .onAppear {
                imageLoader.load(imageName: id)
            }
    }

    private func imageSection(image: UIImage) -> some View {
        Image(uiImage: image)
            .resizable()
            .frame(width: imageSize.width, height: imageSize.height)
            .aspectRatio(contentMode: .fit)
            .clipped()
    }

    var drawBoxView: some View {
        Group {
            if coordinatesChanged {
                DragView(imageSize: imageSize, start: draggingStart, end: draggingEnd)
            }
        }
        .frame(width: imageSize.width, height: imageSize.height)
    }

    var resetButton: some View {
        Button(action: {
            coordinatesChanged = false
            if let snap {
                draggingStart = snap.start.toPoint(imageSize: imageSize)
                draggingEnd = snap.end.toPoint(imageSize: imageSize)
            }
        }) {
            Text("Reset snap bounds")
        }
        .disabled(!coordinatesChanged)
    }
}
