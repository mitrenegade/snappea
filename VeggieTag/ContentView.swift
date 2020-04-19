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
           PlantsView()
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

struct PlantsView: View {
//    var plants: [Plant] = []
    var body: some View {
        List(plantData) { plant in
            PlantRow(plant: plant)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
