//
//  ImageLoaderFactory.swift
//  Snappy
//
//  Created by Bobby Ren on 3/16/24.
//  Copyright © 2024 RenderApps LLC. All rights reserved.
//

import Foundation

class ImageLoaderFactory: ObservableObject {
    let imageLoaderType: any ImageLoader.Type
    var baseURL: URL?

    init(imageLoaderType: any ImageLoader.Type) {
        self.imageLoaderType = imageLoaderType
    }

//    func create(imageName: String, cache: ImageCache?) -> any ImageLoader {
////        return imageLoaderType.init(imageName: imageName, baseUrl: baseURL, cache: cache)
//    }
}
