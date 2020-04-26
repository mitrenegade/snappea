//
//  TagOverlayViewModel.swift
//  VeggieTag
//
//  Created by Bobby Ren on 4/25/20.
//  Copyright © 2020 RenderApps LLC. All rights reserved.
//

import Combine
import Foundation
import SwiftUI

class TagOverlayViewModel: ObservableObject {
    @Published var photo: Photo
    @Published var tagViews = [TagView]()
    var urlString: String = ""
    
    @ObservedObject private var loader: ImageLoader

    private var cancellables = Set<AnyCancellable>()
    
    init(photo: Photo, tags: [Tag]) {
        self.photo = photo
        self.loader = ImageLoader(url: URL(string: photo.url)!)
        loader.load()

        $photo
            .map{ $0.url }
            .assign(to: \.urlString, on: self)
            .store(in: &cancellables)

        tagViews = tags.map{TagView(tag: $0)}
    }
    
    var image: some View {
        Group {
            if loader.image != nil {
                Image(uiImage: loader.image!)
                    .resizable()
            }
        }
    }
}
