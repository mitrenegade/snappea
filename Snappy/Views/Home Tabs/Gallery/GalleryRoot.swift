//
//  GalleryRoot.swift
//  Snappy
//
//  Created by Bobby Ren on 1/11/24.
//  Copyright © 2024 RenderApps LLC. All rights reserved.
//

import SwiftUI
import RenderCloud
import Combine

/// Displays a gallery of photos
struct GalleryRoot<T>: View where T: Store {
    @EnvironmentObject var photoEnvironment: PhotoEnvironment

    @ObservedObject var store: T

    // not used
    @State var shouldShowGallery: Bool = true

    init(store: T) {
        self.store = store
    }

    var body: some View {
        NavigationView {
            Group {
                if TESTING {
                    Text("GalleryRoot").font(.title)
                } else {
                    Text("Gallery").font(.title)
                }
                Text("Start with a photo and tag all the plants in it. Click on the plus button to begin.")
                    .padding(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
                Spacer()
                if store.isLoading {
                    Text("Loading...")
                } else {
                    if store.allPhotos.isEmpty {
                        Text("No plants! Click to add some")
                    } else {
                        galleryView
                    }
                }
                newPhotoView
                Spacer()
            }
//            .navigationBarItems(leading: logoutButton)
        }
    }

    var newPhotoView: some View {
        Group {
            if let photo = photoEnvironment.newPhoto {
                NavigationLink(destination: PhotoDetailView(photo: photo,
                                                            store: store),
                               isActive: $photoEnvironment.shouldShowNewPhoto) {
                    EmptyView()
                }
            }
        }
    }

    private var logoutButton = {
        Button(action: {
            LoginViewModel().signOut()
        }) {
            Text("Logout")
        }
    }()

    private var galleryView: some View {
        if #available(iOS 17.0, *) {
            PhotoGalleryView(store: store, shouldShowDetail: false, shouldShowGallery: $shouldShowGallery)
        } else {
            // BR TODO handle safely
            fatalError()
        }
    }
}
