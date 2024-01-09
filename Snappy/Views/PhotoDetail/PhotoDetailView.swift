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
    @EnvironmentObject var photoDetailSettings: PhotoDetailSettings

    private let store: DataStore

    private let apiService: APIService

    private let photo: Photo

    var body: some View {
        VStack {
            imageSection
            listSection
        }
    }

    /// Creates a PhotoDetailView
    /// Given a photo, shows all snaps
    init(photo: Photo, store: DataStore = FirebaseDataStore(), apiService: APIService = FirebaseAPIService()) {
        self.photo = photo
        self.store = store
        self.apiService = apiService
    }

    /// Creates a PhotoDetailView
    /// Given a snap, shows the photo for only the snap
    init?(snap: Snap, store: DataStore = FirebaseDataStore(), apiService: APIService = FirebaseAPIService()) {
        guard let photo = store.photo(withId: snap.photoId) else {
            return nil
        }
        self.photo = photo
        self.store = store
        self.apiService = apiService
    }

    var imageSection: some View {
        SnapOverlayView(photo: photo,
                        store: store,
                        apiService: apiService)
    }
    
    var listSection: some View {
        SnapsListView(photo: photo, store: store)
    }
}

#Preview {
    PhotoDetailView(photo: Stub.photoData[0])
}
