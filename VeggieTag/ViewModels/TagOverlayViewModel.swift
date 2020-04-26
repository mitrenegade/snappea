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
    
    private var cancellables = Set<AnyCancellable>()
    
    init(photo: Photo, tags: [Tag]) {
        self.photo = photo

        tagViews = tags.map{TagView(tag: $0)}
    }
}
