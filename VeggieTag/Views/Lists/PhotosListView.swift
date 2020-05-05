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
        if AuthenticationService.shared.user != nil {
            APIService.shared.loadGarden()
        }
    }

    var body: some View {
        NavigationView{
            Group {
                if APIService.shared.photos.count == 0 {
                    Text("Loading...")
                } else {
                    listView
                }
            }
            .navigationBarItems(leading:
                Button(action: {
                    AuthenticationService.shared.signOut()
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

struct PhotosListView_Previews: PreviewProvider {
    static var previews: some View {
        PhotosListView()
    }
}
