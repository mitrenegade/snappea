//
//  HomeView.swift
//  SnapPea
//
//  Created by Bobby Ren on 5/15/20.
//  Copyright © 2020 RenderApps LLC. All rights reserved.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        TabView {
            PhotosRoot()
            .tabItem {
                Image(systemName: "phone.fill")
                Text("Photos")
              }
            CameraRoot()
            .tabItem {
                 Image(systemName: "phone.fill")
                 Text("Camera")
               }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
