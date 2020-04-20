//
//  ContentView.swift
//  VeggieTag
//
//  Created by Bobby Ren on 4/18/20.
//  Copyright © 2020 RenderApps LLC. All rights reserved.
//

import SwiftUI

let plantData: [Plant] = load("plantData.json")

struct ContentView: View {
    var body: some View {
        TabView {
            PlantsView(plants: plantData)
            .tabItem {
                Image(systemName: "phone.fill")
                Text("Plants")
              }
            CameraRoot()
            .tabItem {
                 Image(systemName: "phone.fill")
                 Text("Camera")
               }

        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
