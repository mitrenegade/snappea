//
//  CameraRoot.swift
//  VeggieTag
//
//  Created by Bobby Ren on 4/19/20.
//  Copyright © 2020 RenderApps LLC. All rights reserved.
//

import SwiftUI

struct CameraRoot: View {
    @State var image: Image? = nil

    var body: some View {
        VStack {
            Button(action: {
            }) {
                Text("Take photo")
            }
            image?.resizable()
            .frame(width: 250, height: 250)
            .clipShape(Circle())
            .overlay(Circle().stroke(Color.white, lineWidth: 4))
            .shadow(radius: 10)
        }
    }
}

struct CameraRoot_Previews: PreviewProvider {
    static var previews: some View {
        CameraRoot()
    }
}
