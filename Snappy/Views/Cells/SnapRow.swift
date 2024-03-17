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
    private let imageSize = CGSize(width: 50, height: 50)

    private let imageLoaderFactory: ImageLoaderFactory

    var body: some View {
        HStack {
            if AIRPLANE_MODE {
                // TODO: how to resize image to fit?
                Image("peas")
                    .resizable()
                    .frame(width: imageSize.width, height: imageSize.height)
                    .aspectRatio(contentMode: .fit)
                    .clipped()
            } else {
                let imageLoader = imageLoaderFactory.create(imageName: photo.id, cache: TemporaryImageCache.shared)
                let placeholder = Image("folder.badge.questionmark").frame(width: imageSize.width, height: imageSize.height)
                AsyncImageView(imageLoader: imageLoader, frame: imageSize, placeholder: placeholder)
                    .aspectRatio(contentMode: .fill)
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
    
    init?(snap: Snap,
          photo: Photo,
          isDisabled: Bool = false,
          imageLoaderFactory: ImageLoaderFactory
    ) {
        self.snap = snap
        self.photo = photo
        self.isDisabled = isDisabled
        self.imageLoaderFactory = imageLoaderFactory

        dateString = photo.dateString
        notes = snap.notes
    }
}

//#Preview {
//    SnapRow(snap: Stub.snapData[0], store: MockStore())
//}
