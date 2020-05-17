//
//  PhotosRoot.swift
//  SnapPea
//
//  Created by Bobby Ren on 4/19/20.
//  Copyright © 2020 RenderApps LLC. All rights reserved.
//

import SwiftUI
import Combine

struct PhotosRoot: View {
    @ObservedObject var viewModel: PhotosListViewModel
    var auth: AuthenticationService
    
    private var cancellables = Set<AnyCancellable>()
    
    init(router: HomeViewRouter,
         auth: AuthenticationService = AuthenticationService.shared,
         apiService: APIService = APIService.shared) {
        self.auth = auth
        
        viewModel = PhotosListViewModel(apiService: apiService, router: router)
        if auth.user != nil {
            apiService.loadGarden()
        }
    }

    var body: some View {
        NavigationView{
            Group {
                if viewModel.dataSource.count == 0 {
                    Text("Loading...")
                } else {
                    listView
                }
            }
            .navigationBarItems(leading:
                Button(action: {
                    self.auth.signOut()
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
}

struct PhotosRoot_Previews: PreviewProvider {
    static var previews: some View {
        PhotosRoot(router: HomeViewRouter())
    }
}
