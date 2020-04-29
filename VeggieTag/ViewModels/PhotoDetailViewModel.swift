//
//  PhotoViewModel.swift
//  VeggieTag
//
//  Created by Bobby Ren on 4/20/20.
//  Copyright © 2020 RenderApps LLC. All rights reserved.
//

import Combine
import Foundation

class PhotoDetailViewModel: ObservableObject {
    // stored model
    var photo: Photo
    
    // datasource
    @Published var tags = [Tag]()

    private var cancellables = Set<AnyCancellable>()
    
    init(photo: Photo) {
        self.photo = photo
        
        tags = DataSample.tagData
            .filter{ $0.photoId == photo.id }
    }
}
