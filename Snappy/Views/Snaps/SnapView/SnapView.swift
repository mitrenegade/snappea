//
//  SnapView.swift
//  Snappy
//
//  Created by Bobby Ren on 4/21/20.
//  Copyright © 2020 RenderApps LLC. All rights reserved.
//

import SwiftUI

/// A bounding box representing a snapshot of a plant
/// to be displayed on top of a photo
struct SnapView: View, Identifiable {
    @ObservedObject var viewModel: SnapViewModel
    var id: String?
    
    init(snap: Snap, size: CGSize) {
        self.viewModel = SnapViewModel(snap: snap, imageWidth: size.width, imageHeight: size.height)
        id = snap.id
    }

    var body: some View {
        Rectangle()
            .size(width: $viewModel.width.wrappedValue,
                   height: $viewModel.height.wrappedValue)
            .stroke(viewModel.color, lineWidth: 5)
            .offset(x: $viewModel.x0.wrappedValue,
                    y: $viewModel.y0.wrappedValue)
    }
}
