//
//  TagRow.swift
//  Snappy
//
//  Created by Bobby Ren on 4/19/20.
//  Copyright © 2020 RenderApps LLC. All rights reserved.
//

import SwiftUI

struct SnapRow: View {
    private let snap: Snap // TODO: use SnapRowViewModel
    private let name: String

    var body: some View {
        Text(name)
    }
    
    init(snap: Snap, dataStore: DataStore = FirebaseDataStore()) {
        self.snap = snap
        name = dataStore.plant(withId: snap.plantId)?.name ?? "Unknown plant (\(snap.id))"
    }
}

#Preview {
    SnapRow(snap: Stub.snapData[0])
}
