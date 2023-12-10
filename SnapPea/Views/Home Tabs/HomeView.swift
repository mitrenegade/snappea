//
//  HomeView.swift
//  SnapPea
//
//  Created by Bobby Ren on 5/15/20.
//  Copyright © 2020 RenderApps LLC. All rights reserved.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var router: HomeViewRouter = HomeViewRouter()
    
    var body: some View {
        TabView(selection: $router.selectedTab) {
            PhotosRoot(router: router)
            .tabItem {
                Image(systemName: "phone.fill")
                Text("Photos")
            }.tag(Tab.photos)
            CameraRoot(router: router)
            .tabItem {
                 Image(systemName: "phone.fill")
                 Text("Camera")
            }.tag(Tab.camera)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
