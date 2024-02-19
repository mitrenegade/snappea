//
//  HomeView.swift
//  Snappy
//
//  Created by Bobby Ren on 5/15/20.
//  Copyright © 2020 RenderApps LLC. All rights reserved.
//

import SwiftUI

struct HomeView<T>: View where T: Store {
    @ObservedObject var router: HomeViewRouter
    @ObservedObject var store: T

    init(store: T) {
        self.router = HomeViewRouter()
        self.store = store
    }

    var body: some View {
        TabView(selection: $router.selectedTab) {
            PlantsRoot(store: store)
                .tabItem {
                    // BR TODO make this a snap pea icon
                    Image(systemName: "leaf.fill")
                    Text("Plants")
                }.tag(Tab.plants)
            GalleryRoot(store: store)
                .tabItem {
                    Image(systemName: "photo.fill")
                    Text("Gallery")
                }.tag(Tab.camera)
            CameraRoot(router: router, store: store)
                .tabItem {
                    Image(systemName: "camera.fill")
                    Text("Camera")
                }.tag(Tab.camera)
        }
    }
}

//struct HomeView_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeView(store: MockStore())
//    }
//}
