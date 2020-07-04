//
//  PhotoDetailView.swift
//  SnapPea
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
//            imageSection
            TagOverlayView(photo: $photoDetailViewModel.photo.wrappedValue) { photo in
                self.photoDetailViewModel.photo = photo
            }

//            listSection
            TagsListView(photo: $photoDetailViewModel.photo.wrappedValue)
        }
    }
    
    init(photo: Photo) {
        self.photoDetailViewModel = PhotoDetailViewModel(photo: photo)
    }
    
    var imageSection: some View {
        TagOverlayView(photo: $photoDetailViewModel.photo.wrappedValue) { photo in
            self.photoDetailViewModel.photo = photo
        }
    }
    
    var listSection: some View {
        TagsListView(photo: $photoDetailViewModel.photo.wrappedValue)
    }
}

struct PhotoDetailView_Previews: PreviewProvider {
    static var previews: some View {
        PhotoDetailView(photo: DataHelper.photoData[0])
    }
}
