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
struct GalleryRoot: View {
    private let store: Store

    @ObservedObject var viewModel: PhotoGalleryViewModel

    init(router: HomeViewRouter,
         store: Store = FirebaseStore()
    ) {
        viewModel = PhotoGalleryViewModel(store: store)
        self.store = store
    }

    var body: some View {
        NavigationStack{
            Group {
                if TESTING {
                    Text("GalleryRoot").font(.title)
                } else {
                    Text("Gallery").font(.title)
                }
                Text("Start with a photo and tag all the plants in it. Click on the plus button to begin.")
                    .padding(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
                Spacer()
                if viewModel.isLoading {
                    Text("Loading...")
                } else {
                    if viewModel.dataSource.isEmpty {
                        Text("No plants! Click to add some")
                    } else {
                        galleryView
                    }
                }
                Spacer()
            }
            .navigationBarItems(leading: logoutButton)
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
            PhotoGalleryView(store: store)
                .environment(viewModel)
        } else {
            // BR TODO handle safely
            fatalError()
        }
    }
}
