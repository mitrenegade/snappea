//
//  PhotoDetailView.swift
//  Snappy
//
//  Created by Bobby Ren on 4/21/20.
//  Copyright © 2020 RenderApps LLC. All rights reserved.
//

import SwiftUI
import Combine

struct PhotoDetailView: View {
    @ObservedObject var photoDetailViewModel: PhotoDetailViewModel
    @EnvironmentObject var photoDetailSettings: PhotoDetailSettings

    private let store: DataStore

    var body: some View {
        VStack {
            imageSection
            listSection
        }
    }

    /// Creates a PhotoDetailView
    /// Given a photo, shows all snaps
    init(photo: Photo, store: DataStore = FirebaseDataStore()) {
        self.store = store
        self.photoDetailViewModel = PhotoDetailViewModel(photo: photo)
    }

    /// Creates a PhotoDetailView
    /// Given a snap, shows the photo for only the snap
    init?(snap: Snap, store: DataStore = FirebaseDataStore()) {
        guard let photo = store.photo(withId: snap.photoId) else {
            return nil
        }
        self.store = store
        self.photoDetailViewModel = PhotoDetailViewModel(photo: photo)
    }

    var imageSection: some View {
        SnapOverlayView(photo: $photoDetailViewModel.photo.wrappedValue) { photo in
            self.photoDetailViewModel.photo = photo
        }
    }
    
    var listSection: some View {
        SnapsListView(photo: $photoDetailViewModel.photo.wrappedValue)
    }
}

#Preview {
    PhotoDetailView(photo: Stub.photoData[0])
}
