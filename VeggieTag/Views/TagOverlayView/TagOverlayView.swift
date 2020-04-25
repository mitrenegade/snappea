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
    var url: URL?
    var imageName: String?
    @State var hasUrl: Bool = false
    
    init(urlString: String, tags: [Tag]) {
        self.url = URL(string: urlString)
        self.tags = tags
        hasUrl = true
    }
    
    init(imageName: String, tags: [Tag]) {
        self.imageName = imageName
        self.tags = tags
        hasUrl = false
    }
    
    var body: some View {
        ZStack {
            if hasUrl {
                AsyncImageView(url: url!,
                               placeholder: Text("Loading..."))
                    .border(Color.black)
                .aspectRatio(1, contentMode: .fit)
            } else {
                ImageStore.shared.image(name: imageName!)
                    .resizable()
                .aspectRatio(1, contentMode: .fit)
            }
            ForEach(tags) {tag in
                TagView(tag: tag)
            }
        }
    }
}

struct TagOverlayView_Previews: PreviewProvider {
    static var previews: some View {
        TagOverlayView(imageName: "veggieSquare", tags: tagData)
    }
}

