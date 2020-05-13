//
//  DragView.swift
//  SnapPea
//
//  Created by Bobby Ren on 5/10/20.
//  Copyright © 2020 RenderApps LLC. All rights reserved.
//

import SwiftUI

struct DragView: View, Identifiable {
    var id: String
    
    @ObservedObject var viewModel: DragViewModel
    init(imageSize: CGSize, start: CGPoint, end: CGPoint) {
        self.id = UUID().uuidString
        self.viewModel = DragViewModel(imageSize: imageSize,
                                       start: start,
                                       end: end)
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
