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

struct AsyncImageView<Placeholder: View, T: ImageLoader>: View {
    @ObservedObject var imageLoader: T
    let frame: CGSize?
    let placeholder: Placeholder?

    @State private var image: UIImage?

    var body: some View {
        imageView
    }
    
    var imageView: some View {
        Group {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .frame(width: self.frame?.width, height: self.frame?.height, alignment: .center)
            } else {
                placeholder
            }
        }
        .onReceive(imageLoader.imagePublisher, perform: { image in
            if let image {
                self.image = image
            }
        })
    }
}
