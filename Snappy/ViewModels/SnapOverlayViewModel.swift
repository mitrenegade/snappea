//
//  SnapOverlayViewModel.swift
//  Snappy
//
//  Created by Bobby Ren on 4/25/20.
//  Copyright © 2020 RenderApps LLC. All rights reserved.
//

import Combine
import Foundation
import SwiftUI

class SnapOverlayViewModel: ObservableObject {
    @Published var photo: Photo
    @Published var snaps: [Snap] = []
    @Published var url: URL = URL(string: "www.google.com")!
    
    var photoId: String?

    private let store: Store

    private var cancellables = Set<AnyCancellable>()
    
    /// - Parameters:
    ///     - photo: the Photo to be displayed which is related to the snaps.
    ///     - selectedSnaps: if non-nil, a custom set of snaps. This may be a subset of the snaps for the photo, or  used to display a single snap
    init(photo: Photo,
         selectedSnaps: [Snap]? = nil,
         store: Store = FirebaseStore()) {
        self.photo = photo
        self.store = store
        self.snaps = selectedSnaps ?? fetchSnapsForPhoto(id: photo.id)

        // assign url
        $photo
            .map{ URL(string: $0.url)! }
            .assign(to: \.url, on: self)
            .store(in: &cancellables)
        
        $photo.map{ $0.id }
            .assign(to: \.photoId, on: self)
            .store(in: &cancellables)
    }

    private func fetchSnapsForPhoto(id: String) -> [Snap] {
        store.allSnaps.filter { $0.photoId == id }
    }

    func createSnap(start: CGPoint, end: CGPoint, imageSize: CGSize) {
        guard let photoId = photoId else { return }
        let (startCoord, endCoord) = CoordinateService.getValidCoordinatesFromPixels(imageSize: imageSize, start: start, end: end)

        print("createSnap startCoord: \(startCoord) endCoord \(endCoord)")

        let snap = Snap(photoId: photoId, start: startCoord, end: endCoord)

        try? store.store(snap: snap)
        snaps.append(snap)
    }
}
