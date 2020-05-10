//
//  PhotoViewModel.swift
//  SnapPea
//
//  Created by Bobby Ren on 4/20/20.
//  Copyright © 2020 RenderApps LLC. All rights reserved.
//

import Combine
import Foundation

class PhotoDetailViewModel: ObservableObject {
    // stored model
    @Published var photo: Photo
    
    // datasource
    @Published var tags: [Tag] = []

    private var cancellables = Set<AnyCancellable>()
    
    init(photo: Photo) {
        self.photo = photo
        
        $photo
            .map{ $0.tags }
            .assign(to: \.tags, on: self)
            .store(in: &cancellables)
    }
}
