//
//  TagsView.swift
//  Snappy
//
//  Created by Bobby Ren on 4/19/20.
//  Copyright © 2020 RenderApps LLC. All rights reserved.
//

import SwiftUI

struct SnapsListView: View {
    @ObservedObject var viewModel: SnapsListViewModel
    var body: some View {
        List(viewModel.dataSource) { snap in
            SnapRow(snap: snap)
        }
    }
    
    init(photo: Photo) {
        self.viewModel = SnapsListViewModel(photo: photo)
    }
}

#Preview {
    SnapsListView(photo: Stub.photoData[0])
}
