//
//  ImageCache.swift
//  VeggieTag
//
//  Created by Bobby Ren on 4/26/20.
//  Copyright © 2020 RenderApps LLC. All rights reserved.
//
import Foundation
import UIKit

protocol ImageCache {
    subscript(_ url: URL) -> UIImage? { get set }
}

struct TemporaryImageCache: ImageCache {
    static let shared = TemporaryImageCache()

    private let cache = NSCache<NSURL, UIImage>()
    
    subscript(_ key: URL) -> UIImage? {
        get { cache.object(forKey: key as NSURL) }
        set { newValue == nil ? cache.removeObject(forKey: key as NSURL) : cache.setObject(newValue!, forKey: key as NSURL) }
    }
}
