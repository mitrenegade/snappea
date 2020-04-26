//
//  TagOverlayView.swift
//  VeggieTag
//
//  Created by Bobby Ren on 4/21/20.
//  Copyright © 2020 RenderApps LLC. All rights reserved.
//

import SwiftUI

struct TagOverlayView: View {
    @ObservedObject var viewModel: TagOverlayViewModel

    init(urlString: String, tags: [Tag]) {
        viewModel = TagOverlayViewModel(urlString: urlString, tags: tags)
    }
    
    var body: some View {
        ZStack {
            viewModel.image
            ForEach(viewModel.tagViews) {tagView in
                tagView
            }
        }
    }
}

struct TagOverlayView_Previews: PreviewProvider {
    static var previews: some View {
        TagOverlayView(urlString: "veggieSquare", tags: tagData)
    }
}

