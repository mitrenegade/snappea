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

    private var apiService: APIService {
        if AIRPLANE_MODE {
            let dataStore: DataStore = MockDataStore()
            return APIService(dataStore: dataStore)
        } else {
            return APIService.shared
        }
    }

    var body: some View {
        TabView(selection: $router.selectedTab) {
            PlantsRoot(router: router, apiService: apiService)
            .tabItem {
                // BR TODO make this a snap pea icon
                Image(systemName: "leaf.fill")
                Text("Plants")
            }.tag(Tab.plants)
            CameraRoot(router: router)
            .tabItem {
                 Image(systemName: "camera.fill")
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
