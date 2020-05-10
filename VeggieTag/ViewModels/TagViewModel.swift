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
            .map{ _ in self.getX0() }
            .assign(to: \.x0, on: self)
            .store(in: &cancellables)

        // y0
        $tag
            .map{ _ in self.getY0() }
            .assign(to: \.y0, on: self)
            .store(in: &cancellables)

        // width
        $tag
            .map{ _ in self.getWidth() }
            .assign(to: \.width, on: self)
            .store(in: &cancellables)

        // height
        $tag
            .map{ _ in self.getHeight() }
        .assign(to: \.height, on: self)
            .store(in: &cancellables)

        print("Tag id \(tag.id) \(tag.x0) \(tag.y0) \(tag.x1) \(tag.y1) converted to rect \(self.x0) \(self.y0) width \(self.width) height \(self.height) Screen \(self.imageWidth) \(self.imageHeight)")
    }
    
    var color: Color {
        if tag.id == "jpyGfohCIRD3bIzWaRV5" {
            return .red
        } else if tag.id == "oAB6udZf3IdDBDFfpaIG" {
            return .green
        } else {
            return .blue
        }
    }
    var isTap: Bool {
        return tag.x1 == nil
    }
    
    func getX0() -> CGFloat {
        if tag.id == "jpyGfohCIRD3bIzWaRV5" {
            return 20
        } else if tag.id == "oAB6udZf3IdDBDFfpaIG" {
            return 10
        } else {
            return 0
        }
        let startX = self.coordToPixelPosition(point: tag.x0, maxWidth: self.imageWidth)
        let tapOffset = isTap ? self.defaultSize / 2 : 0
        return startX - tapOffset
    }
    
    func getY0() -> CGFloat {
        if tag.id == "jpyGfohCIRD3bIzWaRV5" || tag.id == "oAB6udZf3IdDBDFfpaIG" {
            return 0
        } else {
            return 0
        }
        let startY = -1 * self.coordToPixelPosition(point: tag.y0, maxWidth: self.imageHeight)
        let tapOffset = isTap ? self.defaultSize / -2 : 0
        return startY - tapOffset
    }
    
    func getWidth() -> CGFloat {
        if tag.id == "jpyGfohCIRD3bIzWaRV5" {
            return 40 //62
        } else if tag.id == "oAB6udZf3IdDBDFfpaIG" {
            return 40 //60
        } else {
            return 40
        }
        if isTap {
            return self.defaultSize
        }
        let endX = self.coordToPixelPosition(point: tag.x1 ?? 0, maxWidth: imageWidth)
        return endX - self.getX0()
    }

    func getHeight() -> CGFloat {
        if tag.id == "jpyGfohCIRD3bIzWaRV5" {
            return 60
        }
        if tag.id == "oAB6udZf3IdDBDFfpaIG" {
            return 40
        }
        return 20
        if isTap {
            return self.defaultSize
        }
        let endY = self.coordToPixelPosition(point: tag.y1 ?? 0, maxWidth: imageHeight)
        return endY - self.getY0()
    }

    internal func coordToPixelPosition(point: CGFloat, maxWidth: CGFloat) -> CGFloat{
        // converts [-1, 1] to [-maxWidth/2:maxWidth/2]
        return point * maxWidth / 2
    }
}
