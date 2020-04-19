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
    var body: some View {
        Text("Here be your plants")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
