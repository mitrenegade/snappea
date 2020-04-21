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
    @Published var photo: Photo
    @Published var tags = [Tag]()
    var url: URL = URL(string: "www.google.com")!
    private var cancellables = Set<AnyCancellable>()
    
    init(photo: Photo) {
        self.photo = photo
        
        // assign url
        $photo
            .map{ URL(string: $0.url)! }
            .assign(to: \.url, on: self)
            .store(in: &cancellables)
        
        tags = tagData
            .filter{ $0.photoId == photo.id }
    }
}
