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
        TagOverlayView(photo: $photoDetailViewModel.photo.wrappedValue)
    }
    
    var listSection: some View {
        TagsListView(tags: $photoDetailViewModel.tags.wrappedValue)
    }
}

struct PhotoDetailView_Previews: PreviewProvider {
    static var previews: some View {
        PhotoDetailView(photo: DataHelper.photoData[0])
    }
}
