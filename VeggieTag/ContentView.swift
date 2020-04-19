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
                Text("First Tab")
              }
            Text("The content of the second view")
              .tabItem {
                 Image(systemName: "phone.fill")
                 Text("Second Tab")
               }

        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
