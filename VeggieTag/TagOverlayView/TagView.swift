//
//  TagView.swift
//  VeggieTag
//
//  Created by Bobby Ren on 4/21/20.
//  Copyright © 2020 RenderApps LLC. All rights reserved.
//

import SwiftUI

struct TagView: View {
    var tag: Taggable
    
    init(tag: Taggable) {
        self.tag = tag
    }
    
    var body: some View {
        // TODO: scale and translate based on taggable
        RoundedRectangle(cornerRadius: 4)
        .stroke(Color.blue, lineWidth: 4)
            .offset(x: tag.x, y: tag.y)
    }
}
