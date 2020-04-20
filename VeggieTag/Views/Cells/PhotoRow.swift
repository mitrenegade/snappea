
//
//  PhotoRow.swift
//  VeggieTag
//
//  Created by Bobby Ren on 4/19/20.
//  Copyright © 2020 RenderApps LLC. All rights reserved.
//

import SwiftUI

struct PhotoRow: View {
    var photo: Photo
    
    var body: some View {
        HStack {
            AsyncImageView(url: URL(string: photo.url)!, placeholder: Text("Loading..."))
                .aspectRatio(contentMode: .fit)
            Text(photo.dateString)
        }
    }
}

//struct PhotoRow_Previews: PreviewProvider {
//    static var previews: some View {
//        PhotoRow(plant: plantData[0])
//    }
//}
