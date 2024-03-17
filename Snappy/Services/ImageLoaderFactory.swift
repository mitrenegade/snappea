//
//  ImageLoaderFactory.swift
//  Snappy
//
//  Created by Bobby Ren on 3/16/24.
//  Copyright © 2024 RenderApps LLC. All rights reserved.
//

import Foundation

struct ImageLoaderFactory {
    let imageLoaderType: any ImageLoader.Type
    let baseURL: URL

    func create(imageName: String, cache: ImageCache?) -> any ImageLoader {
        imageLoaderType.init(imageName: imageName, baseUrl: baseURL, cache: cache)
    }
}
