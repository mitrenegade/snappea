//
//  PhotoDetailView.swift
//  VeggieTag
//
//  Created by Bobby Ren on 4/21/20.
//  Copyright © 2020 RenderApps LLC. All rights reserved.
//

import SwiftUI
import Combine

struct PhotoDetailView: View {
    @ObservedObject var photoDetailViewModel: PhotoDetailViewModel

    var body: some View {
        VStack {
            TagOverlayView(url: $photoDetailViewModel.url.wrappedValue, tags: $photoDetailViewModel.tags.wrappedValue)
            // TODO: TagOverlayView doesn't scale to fit
            List($photoDetailViewModel.tags.wrappedValue) { tag in
                TagRow(tag: tag)
            }
        }
    }
    
    init(photo: Photo) {
        self.photoDetailViewModel = PhotoDetailViewModel(photo: photo)
    }
}

struct PhotoDetailView_Previews: PreviewProvider {
    static var previews: some View {
        PhotoDetailView(photo: photoData[0])
    }
}
