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
        SnapOverlayView(photo: $photoDetailViewModel.photo.wrappedValue) { photo in
            self.photoDetailViewModel.photo = photo
        }
    }
    
    var listSection: some View {
        SnapsListView(photo: $photoDetailViewModel.photo.wrappedValue)
    }
}

#Preview {
    PhotoDetailView(photo: Stub.photoData[0])
}
