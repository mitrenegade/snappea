//
//  TagView.swift
//  VeggieTag
//
//  Created by Bobby Ren on 4/21/20.
//  Copyright © 2020 RenderApps LLC. All rights reserved.
//

import SwiftUI

struct TagView: View, Identifiable {
    @ObservedObject var viewModel: TagViewModel
    var id: String?
    
    init(tag: Tag) {
        let screenWidth = UIScreen.main.bounds.width
        self.viewModel = TagViewModel(tag: tag, imageWidth: screenWidth, imageHeight: screenWidth)
        id = tag.id
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
