//
//  PhotoDetailView.swift
//  Snappy
//
//  Created by Bobby Ren on 4/21/20.
//  Copyright © 2020 RenderApps LLC. All rights reserved.
//

import SwiftUI
import Combine

struct PhotoDetailView: View {
    @ObservedObject var photoDetailViewModel: PhotoDetailViewModel
    @EnvironmentObject var photoDetailSettings: PhotoDetailSettings

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
        PhotoDetailView(photo: Stub.photoData[0])
    }
}
