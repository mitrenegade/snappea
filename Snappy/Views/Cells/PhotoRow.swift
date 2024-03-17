
//
//  PhotoRow.swift
//  Snappy
//
//  Created by Bobby Ren on 4/19/20.
//  Copyright © 2020 RenderApps LLC. All rights reserved.
//

import SwiftUI

struct PhotoRow: View {
    private let imageSize = CGSize(width: 80, height: 80)
    @ObservedObject var photoRowViewModel: PhotoRowViewModel

    private let imageLoaderFactory: ImageLoaderFactory

    init(photo: Photo,
         imageLoaderFactory: ImageLoaderFactory
    ) {
        self.photoRowViewModel = PhotoRowViewModel(photo: photo)
        self.imageLoaderFactory = imageLoaderFactory
    }
    
    var body: some View {
        HStack {
            if AIRPLANE_MODE {
                Image("peas")
                    .resizable()
                    .frame(width: imageSize.width, height: imageSize.height)
                    .aspectRatio(contentMode: .fit)
                    .clipped()
            } else {
                let imageLoader = imageLoaderFactory.create(imageName: $photoRowViewModel.id.wrappedValue, cache: TemporaryImageCache.shared)
                let placeholder = Text("Loading...")
                AsyncImageView(imageLoader: imageLoader, frame: imageSize, placeholder: placeholder)
                    .aspectRatio(contentMode: .fill)
            }
            Text($photoRowViewModel.textString.wrappedValue)
        }
    }
}

//struct PhotoRow_Previews: PreviewProvider {
//    static var previews: some View {
//        PhotoRow(photo: Stub.photoData[0])
//    }
//}
