//
//  ImageCache.swift
//  Snappy
//
//  Created by Bobby Ren on 4/26/20.
//  Copyright © 2020 RenderApps LLC. All rights reserved.
//
import Foundation
import UIKit
import SwiftUI

protocol ImageCache {
    subscript(_ key: String) -> UIImage? { get set }
}

struct TemporaryImageCache: ImageCache {
    static let shared = TemporaryImageCache()

    private let cache = NSCache<NSString, UIImage>()

    subscript(_ key: String) -> UIImage? {
        get { cache.object(forKey: key as NSString) }
        set { newValue == nil ? cache.removeObject(forKey: key as NSString) : cache.setObject(newValue!, forKey: key as NSString) }
    }
}

struct ImageCacheKey: EnvironmentKey {
    static let defaultValue: ImageCache = TemporaryImageCache()
}

extension EnvironmentValues {
    var imageCache: ImageCache {
        get { self[ImageCacheKey.self] }
        set { self[ImageCacheKey.self] = newValue }
    }
}
