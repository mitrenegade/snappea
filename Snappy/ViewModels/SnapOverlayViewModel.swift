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

    private let store: DataStore
    private let apiService: APIService

    private var cancellables = Set<AnyCancellable>()
    
    init(photo: Photo, store: DataStore = FirebaseDataStore(), apiService: APIService = FirebaseAPIService()) {
        self.photo = photo
        self.store = store
        self.apiService = apiService

        // assign url
        $photo
            .map{ URL(string: $0.url)! }
            .assign(to: \.url, on: self)
            .store(in: &cancellables)
        
        $photo.map{ $0.id }
            .assign(to: \.photoId, on: self)
            .store(in: &cancellables)

        // TODO: snap should be the input
        self.snaps = store.allSnaps
//        $photo.map{ $0.snaps }
//            .assign(to: \.snaps, on: self)
//            .store(in: &cancellables)
    }

    func createSnap(start: CGPoint, end: CGPoint, imageSize: CGSize) {
        guard let photoId = photoId else { return }
        let (startCoord, endCoord) = CoordinateService.getValidCoordinatesFromPixels(imageSize: imageSize, start: start, end: end)

        print("createSnap startCoord: \(startCoord) endCoord \(endCoord)")

        let snap = Snap(photoId: photoId, start: startCoord, end: endCoord)

        apiService.addSnap(snap) {_,_ in
            // TODO: update snap locally and refresh view
        }
    }
}
