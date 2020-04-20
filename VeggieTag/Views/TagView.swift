//
//  TagView.swift
//  VeggieTag
//
//  Created by Bobby Ren on 4/19/20.
//  Copyright © 2020 RenderApps LLC. All rights reserved.
//

import SwiftUI

struct TagView: View {
    var tag: Tag
    var body: some View {
        AsyncImageView(url: URL(string: tag.photo?.url ?? "")!, placeholder: Text("Loading..."))
    }
}

struct TagView_Previews: PreviewProvider {
    static var previews: some View {
        TagView(tag: tagData[0])
    }
}
