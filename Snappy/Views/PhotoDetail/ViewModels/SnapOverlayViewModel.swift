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

    private var cancellables = Set<AnyCancellable>()
    
    init(photo: Photo) {
        self.photo = photo

        // assign url
        $photo
            .map{ URL(string: $0.url)! }
            .assign(to: \.url, on: self)
            .store(in: &cancellables)
        
        $photo.map{ $0.id }
            .assign(to: \.photoId, on: self)
            .store(in: &cancellables)

        self.snaps = photo.snaps
//        $photo.map{ $0.snaps }
//            .assign(to: \.snaps, on: self)
//            .store(in: &cancellables)
    }
}
