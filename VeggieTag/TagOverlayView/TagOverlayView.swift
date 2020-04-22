//
//  TagOverlayView.swift
//  VeggieTag
//
//  Created by Bobby Ren on 4/21/20.
//  Copyright © 2020 RenderApps LLC. All rights reserved.
//

import SwiftUI

struct TagOverlayView: View {
    var tags: [Tag]
    var url: URL!
    
    init(url: URL, tags: [Tag]) {
        self.url = url
        self.tags = tags
    }
    
    var body: some View {
        ZStack {
            AsyncImageView(url: url,
                           placeholder: Text("Loading..."))
                .aspectRatio(contentMode: .fit)
            ForEach(tags) {tag in
                TagView(tag: tag)
            }
        }
    }
}
