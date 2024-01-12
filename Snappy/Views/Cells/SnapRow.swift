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
    private var dateString: String
    private let notes: String
    private let photo: Photo
    private let isDisabled: Bool

    var body: some View {
        HStack {
            if let url = URL(string: photo.url) {
                AsyncImageView(url: url,
                               frame: CGSize(width: 50, height: 50),
                               placeholder: Image("folder.badge.questionmark").frame(width: 50, height: 50),
                               cache: TemporaryImageCache.shared)
            } else {
                Image("folder.badge.question")
                    .frame(width: 50, height: 50)
            }
            VStack {
                if !dateString.isEmpty {
                    Text("Taken: \(dateString)")
                }
                Text("Notes: \(notes)")
            }
        }
        .opacity(isDisabled ? 0.5 : 1)
    }
    
    init?(snap: Snap, dataStore: DataStore = FirebaseDataStore(), isDisabled: Bool = false) {
        guard let photo = dataStore.photo(withId: snap.photoId) else {
            return nil
        }

        self.snap = snap
        self.photo = photo
        self.isDisabled = isDisabled

        dateString = photo.dateString
        notes = snap.notes
    }
}

#Preview {
    SnapRow(snap: Stub.snapData[0])
}
