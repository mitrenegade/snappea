//
//  ContentView.swift
//  VeggieTag
//
//  Created by Bobby Ren on 4/18/20.
//  Copyright © 2020 RenderApps LLC. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            TabView {
                PhotosView(photos: photoData)
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
        .navigationBarTitle("My Garden")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
