//
//  ImageLoader.swift
//  VeggieTag
//
//  Created by Bobby Ren on 4/19/20.
//  Copyright © 2020 RenderApps LLC. All rights reserved.
//

import SwiftUI
import Combine
import Foundation

class ImageLoader: ObservableObject {
    @Published var image: UIImage?
    private let url: URL
    private var cancellable: AnyCancellable?
    
    private var cache: ImageCache?
    
    init(url: URL, cache: ImageCache? = TemporaryImageCache.shared) {
        self.url = url
        self.cache = cache
    }
    
    deinit {
        cancellable?.cancel()
    }
    
    func load() {
        if let image = cache?[url] {
            self.image = image
            return
        }
        
        cancellable = URLSession.shared.dataTaskPublisher(for: url)
            .map{ UIImage(data: $0.data) }
            .replaceError(with: nil)
            .handleEvents(receiveOutput: { [weak self] in self?.cached($0) })
            .receive(on: DispatchQueue.main)
            .assign(to: \.image, on: self)
    }
    
    func cancel() {
        cancellable?.cancel()
    }
    
    private func cached(_ image: UIImage?) {
        image.map { cache?[url] = $0 }
    }
    
}
