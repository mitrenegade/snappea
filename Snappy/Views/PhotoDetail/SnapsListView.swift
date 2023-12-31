//
//  TagsView.swift
//  Snappy
//
//  Created by Bobby Ren on 4/19/20.
//  Copyright © 2020 RenderApps LLC. All rights reserved.
//

import SwiftUI

struct SnapsListView: View {
    @ObservedObject var viewModel: SnapsListViewModel

    private let store: DataStore

    var body: some View {
        List(viewModel.snaps) { snap in
            NavigationLink {
                // snap detail
                PhotoDetailView(snap: snap, store: store)
            } label: {
                SnapRow(snap: snap, dataStore: store)
            }
        }
    }
    
    /// Creates a SnapsListView based on a given photo
    init(photo: Photo, store: DataStore = FirebaseDataStore()) {
        self.store = store
        self.viewModel = SnapsListViewModel(photo: photo, store: store)
    }

    /// Creates a SnapsListView based on a given plant
    init(plant: Plant, store: DataStore = FirebaseDataStore()) {
        self.store = store
        self.viewModel = SnapsListViewModel(plant: plant, store: store)
    }
}

#Preview {
    SnapsListView(photo: Stub.photoData[0])
}
