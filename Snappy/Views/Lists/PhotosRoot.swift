//
//  PhotosRoot.swift
//  Snappy
//
//  Created by Bobby Ren on 4/19/20.
//  Copyright © 2020 RenderApps LLC. All rights reserved.
//

import SwiftUI
import RenderCloud
import Combine

struct PhotosRoot: View {
    @ObservedObject var viewModel: PhotosListViewModel
    private let auth: RenderAuthService // BOBBY TODO: use environment variable
    @EnvironmentObject var photoDetailSettings: PhotoDetailSettings
    
    private var cancellables = Set<AnyCancellable>()
    
    init(router: HomeViewRouter,
         auth: RenderAuthService = RenderAuthService(),
         apiService: APIService = APIService.shared) {
        self.auth = auth
        if auth.user != nil {
            apiService.loadGarden()
        }
        
        viewModel = PhotosListViewModel(apiService: apiService, router: router)
    }

    var body: some View {
        NavigationView{
            Group {
                if viewModel.dataSource.count == 0 {
                    Text("Loading...")
                } else {
                    listView
                }
                newPhotoView
            }
            .navigationBarItems(leading:
                Button(action: {
                    try? self.auth.logout()
                }) {
                    Text("Logout")
            })
        }

    }
    
    var listView: some View {
        List(viewModel.dataSource) { photo in
            NavigationLink(destination: PhotoDetailView(photo: photo)) {
                PhotoRow(photo: photo)
            }
        }
    }
    
    var newPhotoView: some View {
        Group {
            if photoDetailSettings.newPhoto != nil {
                NavigationLink(destination: PhotoDetailView(photo: photoDetailSettings.newPhoto!),
                               isActive: $photoDetailSettings.shouldShowNewPhoto) {
                                EmptyView()
                }
            }
        }
    }
}

struct PhotosRoot_Previews: PreviewProvider {
    static var previews: some View {
        PhotosRoot(router: HomeViewRouter())
    }
}
