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
                .border(Color.black)
                .frame(width: 250, height: 250)
            ForEach(tags) {tag in
                TagView(tag: tag)
            }
        }
    }
}

struct TagOverlayView_Previews: PreviewProvider {
    static var previews: some View {
        TagOverlayView(url: URL(string: "https://i.redd.it/gbxhi6mwdvt41.jpg")!, tags: tagData)
    }
}

