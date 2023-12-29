//
//  AddPlantView.swift
//  Snappy
//
//  Created by Bobby Ren on 12/28/23.
//  Copyright © 2023 RenderApps LLC. All rights reserved.
//

import SwiftUI

struct AddPlantView: View {
    var body: some View {
        VStack {
            HStack {
                Button {
                    // camera
                } label: {
                    Image(systemName: "camera")
                }
                .frame(width: 100, height: 100)
                .aspectRatio(contentMode: .fill)
                .foregroundColor(Color.black)
                .background(Color.green)
                .clipShape(Circle())
            }
        }
    }
}

#Preview {
    AddPlantView()
}
