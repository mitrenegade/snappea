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
    var size: CGFloat = 64 // todo: make variable
    var color: Color = .red
    @Published var xOffset: CGFloat = 0
    @Published var yOffset: CGFloat = 0
    
    private var cancellables = Set<AnyCancellable>()

    init(tag: Tag) {
        self.tag = tag
        
        $tag
            .map{ $0.id }
            .assign(to: \.id, on: self)
            .store(in: &cancellables)
        
        $tag
            .map{ $0.x0 }
            .assign(to: \.xOffset, on: self)
            .store(in: &cancellables)

        $tag
            .map{ $0.y0 }
            .assign(to: \.yOffset, on: self)
            .store(in: &cancellables)
    }
}
