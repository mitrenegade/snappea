//
//  PlantBasicView.swift
//  Snappy
//
//  Created by Bobby Ren on 3/8/24.
//  Copyright © 2024 RenderApps LLC. All rights reserved.
//

import Foundation
import SwiftUI

/// Shows individual details for a single plant
struct PlantBasicView: View {
    private let plant: Plant
    private let photo: Photo?
    @EnvironmentObject var imageLoaderFactory: ImageLoaderFactory

    private let imageSize = CGSize(width: 200, height: 200)

    init(plant: Plant,
         photo: Photo?
    ) {
        self.plant = plant
        self.photo = photo
    }

    var body: some View {
        VStack {
            imageView
            Text(plant.name)
                .bold()
            Text(plant.category.rawValue)
            Text(plant.type.rawValue)
        }
    }

    private var imageView: some View {
        Group {
            if let name = photo?.id {
                let imageLoader = imageLoaderFactory.create(imageName: name, cache: TemporaryImageCache.shared)
                let frame = CGSize(width: imageSize.width, height: imageSize.height)
                let placeholder = Text("Loading...")
                AsyncImageView(imageLoader: imageLoader,
                                      frame: frame,
                                      placeholder: placeholder)
                .aspectRatio(contentMode: .fill)
            }
        }
    }
}
