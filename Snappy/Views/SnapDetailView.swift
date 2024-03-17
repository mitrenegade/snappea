//
//  SnapDetailView.swift
//  Snappy
//
//  Created by Bobby Ren on 1/11/24.
//  Copyright © 2024 RenderApps LLC. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

/// Displays a single snap on a photo with options to edit
struct SnapDetailView<T>: View where T: Store {
    @ObservedObject var store: T

    private let imageLoaderFactory: ImageLoaderFactory

    private let snap: Snap

    private let photo: Photo

    var title: String {
        "SnapDetailView: \(snap.id)"
    }

    var body: some View {
        Group {
            if TESTING {
                Text(title)
            }
            VStack {
                imageSection
                editSection
            }
        }
    }

    /// Creates a PhotoDetailView
    /// Given a snap, shows the photo for only the snap
    init?(snap: Snap, 
          store: T,
          imageLoaderFactory: ImageLoaderFactory
    ) {
        guard let photo = store.photo(withId: snap.photoId) else {
            return nil
        }
        self.photo = photo
        self.snap = snap
        self.store = store
        self.imageLoaderFactory = imageLoaderFactory
    }

    var imageSection: some View {
        SnapOverlayView(photo: photo,
                        selectedSnaps: [snap],
                        store: store,
                        imageLoaderFactory: imageLoaderFactory)
    }

    var editSection: some View {
        Text("Editor")
    }
}
