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

    private let snap: Snap

    private let photo: Photo

    private let imageSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width)

    var title: String {
        "SnapDetailView: \(snap.id)"
    }

    var body: some View {
        if TESTING {
            Text(title)
        }
        VStack {
            imageSection
            editSection
        }
    }

    /// Creates a PhotoDetailView
    /// Given a snap, shows the photo for only the snap
    init?(snap: Snap, 
          store: T,
          environment: OverlayEnvironment
    ) {
        guard let photo = store.photo(withId: snap.photoId) else {
            return nil
        }
        self.photo = photo
        self.snap = snap
        self.store = store

        // modifying environment on it is required to clear existing snap information
        environment.isEditingSnap = false
        environment.snap = snap
    }

    var imageSection: some View {
        SnapOverlayView(photo: photo,
                        selectedSnaps: [snap],
                        store: store,
                        imageSize: imageSize)
    }

    var editSection: some View {
        Text("Editor")
    }
}
