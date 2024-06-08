//
//  FirebaseImageLoader.swift
//  Snappy
//
//  Created by Bobby Ren on 5/31/24.
//  Copyright © 2024 RenderApps LLC. All rights reserved.
//

import Foundation
import UIKit
import Combine

class FirebaseImageLoader: ImageLoader, ObservableObject {
    private let imageService = FirebaseImageService()
    private var cache: ImageCache = TemporaryImageCache.shared

    @Published var image: UIImage?
    var imageValue: Published<UIImage?> {
        return _image
    }
    var imagePublisher: Published<UIImage?>.Publisher {
        return $image
    }

    func load(imageName: String) {
        if let image = getFromCache(key: imageName) {
            self.image = image
            return
        }

        imageService.referenceForImage(type: .photo, id: imageName)?.getData(maxSize: .max) { [weak self] data, error in
            if let data {
                let image = UIImage(data: data)
                self?.image = image
                self?.addToCache(image, key: imageName)
            }
        }
    }

    func cancel() {
        // no op
    }

    private func getFromCache(key: String) -> UIImage? {
        print("Get from cache \(key)")
        return cache[key]
    }

    private func addToCache(_ image: UIImage?, key: String) {
        print("Add to cache \(key)")
        image.map { cache[key] = $0 }
    }
}
