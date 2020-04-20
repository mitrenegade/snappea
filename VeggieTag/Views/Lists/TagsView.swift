//
//  TagsView.swift
//  VeggieTag
//
//  Created by Bobby Ren on 4/19/20.
//  Copyright © 2020 RenderApps LLC. All rights reserved.
//

import SwiftUI

struct TagsView: View {
    var tags: [Tag] = []
    var body: some View {
        List(tags) { tag in
            TagRow(tag: tag)
        }
    }
}

struct TagsView_Previews: PreviewProvider {
    static var previews: some View {
        TagsView(tags: tagData)
    }
}
