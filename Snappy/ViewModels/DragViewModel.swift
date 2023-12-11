//
//  DragViewModel.swift
//  Snappy
//
//  Created by Bobby Ren on 5/10/20.
//  Copyright © 2020 RenderApps LLC. All rights reserved.
//

import Combine
import SwiftUI
import Foundation

class DragViewModel: ObservableObject {
    var imageSize: CGSize
    
    @Published var x0: CGFloat = 0
    @Published var y0: CGFloat = 0
    @Published var width: CGFloat = 0
    @Published var height: CGFloat = 0
    
    let defaultSize: CGFloat = 40
    
    private var cancellables = Set<AnyCancellable>()

    init(imageSize: CGSize, start: CGPoint, end: CGPoint) {
        self.imageSize = imageSize
        self.x0 = start.x
        self.y0 = start.y
        self.width = end.x - start.x
        self.height = end.y - start.y
    }
    
    var color: Color {
        return .blue
    }
}
