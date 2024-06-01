//
//  ImageLoader.swift
//  Snappy
//
//  Created by Bobby Ren on 4/19/20.
//  Copyright © 2020 RenderApps LLC. All rights reserved.
//

import SwiftUI
import Combine
import Foundation

protocol ImageLoader: ObservableObject {
    func load(imageName: String)
    func cancel()
    var image: UIImage? { get }
    var imageValue: Published<UIImage?> { get }
    var imagePublisher: Published<UIImage?>.Publisher { get }

    init(imageName: String, baseUrl: URL?, cache: ImageCache?)
}

class NetworkImageLoader: ImageLoader {
    @Published var image: UIImage?
    var imageValue: Published<UIImage?> {
        return _image
    }
    var imagePublisher: Published<UIImage?>.Publisher {
        return $image
    }

//    private let url: URL
    private var baseUrl: URL?
    private var cancellable: AnyCancellable?
    
    private var cache: ImageCache?
    
    required init(imageName: String, baseUrl: URL?, cache: ImageCache? = TemporaryImageCache.shared) {
        self.cache = cache
        self.baseUrl = baseUrl
    }
    
    deinit {
        cancellable?.cancel()
    }
    
    func load(imageName: String) {
        guard let baseUrl else {
            fatalError("NetworkImageLoader: baseURL not set")
        }
        let url = baseUrl.appending(component: imageName)
        if let image = getFromCache(url: url) {
            self.image = image
            return
        }

        cancellable = URLSession.shared.dataTaskPublisher(for: url)
            .map{ UIImage(data: $0.data) }
            .replaceError(with: nil)
            .handleEvents(receiveOutput: { [weak self] in self?.addToCache($0, url: url) })
            .receive(on: DispatchQueue.main)
            .assign(to: \.image, on: self)
    }
    
    func cancel() {
        cancellable?.cancel()
    }
    
    private func getFromCache(url: URL) -> UIImage? {
        print("Get from cache \(url)")
        return cache?[url.absoluteString]
    }

    private func addToCache(_ image: UIImage?, url: URL) {
        print("Add to cache \(url)")
        image.map { cache?[url.absoluteString] = $0 }
    }
    
}

/// Loads a single image via ImageStore
class DiskImageLoader: ImageLoader {
    @Published var image: UIImage?

    var imageValue: Published<UIImage?> {
        return _image
    }

    var imagePublisher: Published<UIImage?>.Publisher {
        return $image
    }

//    private let name: String

    private var cache: ImageCache?

    private let imageStore: ImageStore

    /// - Parameters:
    ///    - url: the url of an actual image
    required init(imageName: String,
                  baseUrl: URL?,
                  cache: ImageCache? = TemporaryImageCache.shared) {
        guard let baseUrl else {
            fatalError("DiskImageLoader: base URL not set")
        }

        self.cache = cache
//        self.name = imageName
        self.imageStore = ImageStore(baseURL: baseUrl)
    }

    func load(imageName: String) {
        // BR TODO: load from cache first
        image = try? imageStore.loadImage(name: imageName)
    }

    func cancel() {
        // no op
//        cancellable?.cancel()
    }
}
