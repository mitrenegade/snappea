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
    @EnvironmentObject var photoDetailSettings: PhotoDetailSettings

    @State var store = MockStore() //LocalStore()

    init(user: User) {
        self.load(user: user)
    }

    private func load(user: User) {
        Task {
            try await store.loadGarden(id: user.id)
        }
    }

    var body: some View {
        TabView(selection: $photoDetailSettings.selectedTab) {
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
                }.tag(Tab.gallery)
            CameraRoot(store: store)
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
