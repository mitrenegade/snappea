//
//  TagRow.swift
//  Snappy
//
//  Created by Bobby Ren on 4/19/20.
//  Copyright © 2020 RenderApps LLC. All rights reserved.
//

import SwiftUI

struct TagRow: View {
    var tag: Tag
    var body: some View {
        Text(tag.plant?.name ?? tag.id ?? "Unknown plant")
    }
    
    init(tag: Tag) {
        self.tag = tag
    }
}

struct TagRow_Previews: PreviewProvider {
    static var previews: some View {
        TagRow(tag: Stub.snapData[0])
    }
}
