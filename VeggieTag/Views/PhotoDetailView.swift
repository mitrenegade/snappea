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
            imageSection
            listSection
        }
    }
    
    init(photo: Photo) {
        self.photoDetailViewModel = PhotoDetailViewModel(photo: photo)
    }
    
    var imageSection: some View {
        TagOverlayView(photo: $photoDetailViewModel.photo.wrappedValue,
                       tags: $photoDetailViewModel.tags.wrappedValue)
        // TODO: TagOverlayView doesn't scale to fit
    }
    
    var listSection: some View {
        List($photoDetailViewModel.tags.wrappedValue) { tag in
            TagRow(tag: tag)
        }
    }
}

struct PhotoDetailView_Previews: PreviewProvider {
    static var previews: some View {
        PhotoDetailView(photo: photoData[0])
    }
}
