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
    @Published var tagViews = [TagView]()
    
    @ObservedObject private var loader: ImageLoader

    private var cancellables = Set<AnyCancellable>()
    
    init(urlString: String?, tags: [Tag]) {
        loader = ImageLoader(url: URL(string: urlString!)!)
        loader.load()

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
