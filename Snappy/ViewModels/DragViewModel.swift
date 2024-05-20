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

    init(imageSize: CGSize, startCoord: NormalizedCoordinate, endCoord: NormalizedCoordinate) {
        self.imageSize = imageSize
        self.x0 = startCoord.x * imageSize.width
        self.y0 = startCoord.y * imageSize.height
        self.width = (endCoord.x - startCoord.x) * imageSize.width
        self.height = (endCoord.y - startCoord.y) * imageSize.height
    }

    var color: Color {
        return .blue
    }
}
