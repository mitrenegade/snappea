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

    /// Used for debugging only
    private let snap: Snap?

    var title: String {
        if let snap {
            return "PhotoDetailView: Snap \(snap.id)"
        } else {
            return "PhotoDetailView: Photo"
        }
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
    init(photo: Photo, store: DataStore = FirebaseDataStore(), apiService: APIService = FirebaseAPIService()) {
        self.snap = nil
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
        self.snap = snap
        self.photo = photo
        self.store = store
        self.apiService = apiService
    }

    private var selectedSnaps: [Snap]? {
        if let snap {
            return [snap]
        }
        return nil
    }

    var imageSection: some View {
        SnapOverlayView(photo: photo,
                        selectedSnaps: selectedSnaps,
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
