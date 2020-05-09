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
        
        // x0
        $tag
            .map{
                let startX = self.coordToPixelPosition(point: $0.x0, maxWidth: self.imageWidth)
                let tapOffset = $0.x1 == nil ? self.defaultSize / 2 : 0
                return startX - tapOffset }
            .assign(to: \.x0, on: self)
            .store(in: &cancellables)

        // y0
        $tag
            .map{
                let startY = -1 * self.coordToPixelPosition(point: $0.y0, maxWidth: imageHeight)
                let tapOffset = $0.y1 == nil ? self.defaultSize / -2 : 0
                return startY - tapOffset }
            .assign(to: \.y0, on: self)
            .store(in: &cancellables)

        // width
        $tag
            .map{
                if $0.x1 == nil {
                    return self.defaultSize
                }
                let endX = self.coordToPixelPosition(point: $0.x1 ?? 0, maxWidth: imageWidth)
                return endX - self.x0
        }
            .assign(to: \.width, on: self)
            .store(in: &cancellables)

        // height
        $tag
            .map{
                if $0.y1 == nil {
                    return self.defaultSize
                }
                let endY = -1 * self.coordToPixelPosition(point: $0.y1 ?? 0, maxWidth: imageHeight)
                return endY - self.y0
        }
        .assign(to: \.height, on: self)
            .store(in: &cancellables)

        print("Tag \(tag.x0) \(tag.y0) \(tag.x1) \(tag.y1) converted to rect \(self.x0) \(self.y0) width \(self.width) height \(self.height) Screen \(self.imageWidth) \(self.imageHeight)")
    }
    
    private func coordToPixelPosition(point: CGFloat, maxWidth: CGFloat) -> CGFloat{
        // converts [-1, 1] to [-maxWidth/2:maxWidth/2]
        return point * maxWidth / 2
    }
}
