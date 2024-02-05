
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

    init(photo: Photo) {
        self.photoRowViewModel = PhotoRowViewModel(photo: photo)
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
                AsyncImageView(url: $photoRowViewModel.url.wrappedValue,
                               frame: CGSize(width: imageSize.width, height: imageSize.height),
                               placeholder: Text("Loading..."),
                               cache: TemporaryImageCache.shared)
                .aspectRatio(contentMode: .fill)
            }
            Text($photoRowViewModel.textString.wrappedValue)
        }
    }
}

struct PhotoRow_Previews: PreviewProvider {
    static var previews: some View {
        PhotoRow(photo: Stub.photoData[0])
    }
}
