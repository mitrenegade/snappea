//
//  HomeView.swift
//  Snappy
//
//  Created by Bobby Ren on 5/15/20.
//  Copyright © 2020 RenderApps LLC. All rights reserved.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var router: HomeViewRouter = HomeViewRouter()

    private var store: Store {
        if AIRPLANE_MODE {
            return MockStore()
        } else {
            return Constants.store
        }
    }

    var body: some View {
        if router.isLoading {
            Text("Loading...")
        } else {
            TabView(selection: $router.selectedTab) {
                PlantsRoot(router: router, store: store)
                    .tabItem {
                        // BR TODO make this a snap pea icon
                        Image(systemName: "leaf.fill")
                        Text("Plants")
                    }.tag(Tab.plants)
                GalleryRoot(router: router, store: store)
                    .tabItem {
                        Image(systemName: "photo.fill")
                        Text("Gallery")
                    }.tag(Tab.camera)
                CameraRoot(router: router)
                    .tabItem {
                        Image(systemName: "camera.fill")
                        Text("Camera")
                    }.tag(Tab.camera)
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
