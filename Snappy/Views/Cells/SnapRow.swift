//
//  TagRow.swift
//  Snappy
//
//  Created by Bobby Ren on 4/19/20.
//  Copyright © 2020 RenderApps LLC. All rights reserved.
//

import SwiftUI

struct SnapRow: View {
    var snap: Snap
    var body: some View {
        Text(snap.plant?.name ?? snap.id ?? "Unknown plant")
    }
    
    init(snap: Snap) {
        self.snap = snap
    }
}

#Preview {
    SnapRow(snap: Stub.snapData[0])
}
