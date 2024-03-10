//
//  AsyncImageView.swift
//  Snappy
//
//  Created by Bobby Ren on 4/19/20.
//  Copyright © 2020 RenderApps LLC. All rights reserved.
//
// TODO: add ImageCache; make threadsafe. See https://www.vadimbulavin.com/asynchronous-swiftui-image-loading-from-url-with-combine-and-swift/

import SwiftUI
import Combine
import Foundation

struct AsyncImageView<Placeholder: View>: View {
    private var loader: any ImageLoader

    private let placeholder: Placeholder?
    private var frame: CGSize?

//    init(url: URL, frame: CGSize?, placeholder: Placeholder? = nil, cache: ImageCache? = nil) {
//        loader = NetworkImageLoader(url: url, cache: cache)
//        self.placeholder = placeholder
//        self.frame = frame
//    }

    init(imageLoader: any ImageLoader, frame: CGSize?, placeholder: Placeholder? = nil) {
        loader = imageLoader
        self.placeholder = placeholder
        self.frame = frame
        loader.load()
    }

    var body: some View {
        image
//            .onAppear(perform: loader.load)
//            .onDisappear(perform: loader.cancel)
    }
    
    var image: some View {
        Group {
            if let image = loader.image  {
                Image(uiImage: image)
                    .resizable()
                    .frame(width: self.frame?.width, height: self.frame?.height, alignment: .center)
            } else {
                placeholder
            }
        }
    }

}
