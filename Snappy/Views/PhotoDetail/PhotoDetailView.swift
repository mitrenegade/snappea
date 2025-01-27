//
//  PhotoDetailView.swift
//  Snappy
//
//  Created by Bobby Ren on 4/21/20.
//  Copyright © 2020 RenderApps LLC. All rights reserved.
//

import SwiftUI
import Combine

/// A detail view based on a photo and all its attributes, including all snaps
struct PhotoDetailView<T>: View where T: Store {
    @ObservedObject var store: T

    private let photo: Photo

    var title: String {
        "PhotoDetailView: \(photo.id)"
    }

    var body: some View {
        if TESTING {
            Text(title)
        }
        VStack {
            imageSection
            listSection
        }
    }

    /// Creates a PhotoDetailView
    /// Given a photo, shows all snaps
    init(photo: Photo,
         store: T
    ) {
        self.photo = photo
        self.store = store
    }

    var imageSection: some View {
        SnapOverlayView(photo: photo,
                        store: store,
                        imageSize: CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width))
    }
    
    var listSection: some View {
        SnapsListView(photo: photo,
                      store: store)
    }
}
