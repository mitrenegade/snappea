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
            .map{ $0.start.x }
            .assign(to: \.x0, on: self)
            .store(in: &cancellables)

        // y0
        $tag
            .map{ $0.start.y }
            .assign(to: \.y0, on: self)
            .store(in: &cancellables)

        // width
        $tag
            .map{ $0.end?.x ?? 0 }
            .assign(to: \.width, on: self)
            .store(in: &cancellables)

        // height
        $tag
            .map{ $0.end?.y ?? 0 }
            .assign(to: \.height, on: self)
            .store(in: &cancellables)
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
        return tag.end == nil
    }
}
