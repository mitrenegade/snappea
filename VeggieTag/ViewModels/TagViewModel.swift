//
//  TagViewModel.swift
//  VeggieTag
//
//  Created by Bobby Ren on 4/20/20.
//  Copyright © 2020 RenderApps LLC. All rights reserved.
//

import Combine
import SwiftUI
import Foundation

class TagViewModel: ObservableObject {
    @Published var tag: Tag
    
    var id: String?
    var color: Color = .red
    
    var imageWidth: CGFloat = 0
    var imageHeight: CGFloat = 0
    
    @Published var x0: CGFloat = 0
    @Published var y0: CGFloat = 0
    @Published var width: CGFloat = 0
    @Published var height: CGFloat = 0
    
    let defaultSize: CGFloat = 40
    
    private var cancellables = Set<AnyCancellable>()

    init(tag: Tag, imageWidth: CGFloat, imageHeight: CGFloat) {
        self.tag = tag
        self.imageWidth = imageWidth
        self.imageHeight = imageHeight
        
        $tag
            .map{ $0.id }
            .assign(to: \.id, on: self)
            .store(in: &cancellables)
        
//        let normalizedX0: CGFloat = (2 * start.x - imageWidth) / imageWidth
//        let normalizedY0: CGFloat = -(2 * start.y - imageHeight) / imageHeight
//        var normalizedX1: CGFloat? = (2 * end.x - imageWidth) / imageWidth
//        var normalizedY1: CGFloat? = -(2 * end.y - imageHeight) / imageHeight
        
        $tag
            .map{ $0.x1 == nil
                ? ($0.x0 * self.imageWidth + imageWidth) / 2 - self.defaultSize / 2
                : ($0.x0 * self.imageWidth + imageWidth) / 2 }
            .assign(to: \.x0, on: self)
            .store(in: &cancellables)

        $tag
            .map{ $0.y1 == nil
                ? ($0.y0 * self.imageHeight + imageHeight) / 2 - self.defaultSize / 2
                : ($0.y0 * self.imageHeight + imageHeight) / 2 }
            .assign(to: \.y0, on: self)
            .store(in: &cancellables)

        $tag
            .map{ $0.x1 == nil
                ? self.defaultSize
                : (($0.x1 ?? 0) * self.imageWidth + imageWidth) / 2 }
            .assign(to: \.width, on: self)
            .store(in: &cancellables)

        $tag
            .map{ $0.y1 == nil
                ? self.defaultSize
                : (($0.y1 ?? 0) * self.imageHeight + imageHeight) / 2 }
            .assign(to: \.height, on: self)
            .store(in: &cancellables)
    }
}
