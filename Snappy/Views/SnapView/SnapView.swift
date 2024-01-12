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
    
    init(snap: Snap) {
        let screenWidth = UIScreen.main.bounds.width
        self.viewModel = SnapViewModel(snap: snap, imageWidth: screenWidth, imageHeight: screenWidth)
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
