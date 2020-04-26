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
    var photo: Photo
    @ObservedObject var photoDetailViewModel: PhotoDetailViewModel

    var body: some View {
        VStack {
            TagOverlayView(photo: photo,
                           tags: $photoDetailViewModel.tags.wrappedValue)
            // TODO: TagOverlayView doesn't scale to fit
            List($photoDetailViewModel.tags.wrappedValue) { tag in
                TagRow(tag: tag)
            }
        }
    }
    
    init(photo: Photo) {
        self.photo = photo
        self.photoDetailViewModel = PhotoDetailViewModel(photo: photo)
    }
}

struct PhotoDetailView_Previews: PreviewProvider {
    static var previews: some View {
        PhotoDetailView(photo: photoData[0])
    }
}
