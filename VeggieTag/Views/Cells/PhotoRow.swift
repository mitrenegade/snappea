
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
            Text(photo.url)
        }
    }
}

//struct PhotoRow_Previews: PreviewProvider {
//    static var previews: some View {
//        PhotoRow(plant: plantData[0])
//    }
//}
