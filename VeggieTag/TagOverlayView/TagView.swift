//
//  TagView.swift
//  VeggieTag
//
//  Created by Bobby Ren on 4/21/20.
//  Copyright © 2020 RenderApps LLC. All rights reserved.
//

import SwiftUI

struct TagView: View {
    @ObservedObject var viewModel: TagViewModel
    
    init(tag: Taggable) {
        self.viewModel = TagViewModel(tag: tag)
    }
    
    var body: some View {
        Rectangle()
            .stroke(viewModel.color, lineWidth: 5)
            .frame(width: $viewModel.size.wrappedValue,
                   height: $viewModel.size.wrappedValue)
            .offset(x: $viewModel.xOffset.wrappedValue,
                    y: $viewModel.yOffset.wrappedValue)
    }
}
