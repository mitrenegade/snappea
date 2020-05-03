//
//  PhotosView.swift
//  VeggieTag
//
//  Created by Bobby Ren on 4/19/20.
//  Copyright © 2020 RenderApps LLC. All rights reserved.
//

import SwiftUI

struct PhotosListView: View {
    var viewModel: PhotosListViewModel = PhotosListViewModel()

    init() {
        AuthenticationService.shared.$user.compactMap { $0 }
            .sink {
                APIService.shared.loadGarden()
            }
    }
    var body: some View {
        Group {
            if APIService.shared.photos.count == 0 {
                Text("Loading...")
            } else {
                listView
            }
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

struct PhotosListView_Previews: PreviewProvider {
    static var previews: some View {
        PhotosListView()
    }
}
