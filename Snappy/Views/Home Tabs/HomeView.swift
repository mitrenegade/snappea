//
//  HomeView.swift
//  Snappy
//
//  Created by Bobby Ren on 5/15/20.
//  Copyright © 2020 RenderApps LLC. All rights reserved.
//

import SwiftUI

enum Tab: Hashable {
    case plants
    case gallery
    case camera
}

struct HomeView: View {
    @EnvironmentObject var router: TabsRouter

    @State var store = FirebaseStore()
    private var imageLoaderFactory: ImageLoaderFactory = ImageLoaderFactory(imageLoaderType: DiskImageLoader.self)

    init(user: User) {
//        store.purge(id: user.id)
        self.load(user: user)
    }

    private func load(user: User) {
        Task {
            store.setup(gardenID: user.id)
            // TODO: support Firebase
            if let localStore = store as? LocalStore {
                imageLoaderFactory.baseURL = localStore.imageBaseURL
            }
            try await store.loadGarden()
        }
    }

    var body: some View {
        TabView(selection: $router.selectedTab) {
            PlantsRoot(store: store)
                .tabItem {
                    // BR TODO make this a snap pea icon
                    Image(systemName: "leaf.fill")
                    Text("Plants")
                }.tag(Tab.plants)
            // don't show gallery - only plants interface for now
//            GalleryRoot(store: store)
//                .tabItem {
//                    Image(systemName: "photo.fill")
//                    Text("Gallery")
//                }.tag(Tab.gallery)
            CameraRoot(store: store)
                .tabItem {
                    Image(systemName: "camera.fill")
                    Text("Camera")
                }.tag(Tab.camera)
        }
        .environmentObject(imageLoaderFactory)
    }
}

//struct HomeView_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeView(store: MockStore())
//    }
//}
