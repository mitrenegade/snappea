//
//  PhotosView.swift
//  VeggieTag
//
//  Created by Bobby Ren on 4/19/20.
//  Copyright © 2020 RenderApps LLC. All rights reserved.
//

import SwiftUI

struct PhotosView: View {
    var photos: [Photo] = []
    var body: some View {
        List(photos) { photo in
            PhotoRow(photo: photo)
        }
    }
}

struct PhotosView_Previews: PreviewProvider {
    static var previews: some View {
        PhotosView(photos: photoData)
    }
}
