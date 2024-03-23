//
//  PlantRow.swift
//  Snappy
//
//  Created by Bobby Ren on 12/11/23.
//  Copyright © 2023 RenderApps LLC. All rights reserved.
//

import SwiftUI

struct PlantRow: View {
    @ObservedObject var plantRowViewModel: PlantRowViewModel

    @EnvironmentObject var imageLoaderFactory: ImageLoaderFactory

    init(viewModel: PlantRowViewModel) {
        self.plantRowViewModel = viewModel
    }

    var body: some View {
        HStack {
            if let name = plantRowViewModel.photoId {
                let imageLoader = imageLoaderFactory.create(imageName: name, cache: TemporaryImageCache.shared)
                let frame = CGSize(width: 80, height: 80)
                let placeholder = Image(systemName: "tree.fill")
                AsyncImageView(imageLoader: imageLoader, frame: frame, placeholder: placeholder)
                    .aspectRatio(contentMode: .fill)
            } else {
                Image(systemName: "camera")
            }
            Text($plantRowViewModel.name.wrappedValue)
            Text($plantRowViewModel.categoryString.wrappedValue)
                .foregroundColor(Color($plantRowViewModel.categoryColor.wrappedValue))
            Text($plantRowViewModel.typeString.wrappedValue)
                .foregroundColor(Color($plantRowViewModel.typeColor.wrappedValue))
        }
    }
}

//#Preview {
//    PlantRow(viewModel: PlantRowViewModel(plant: Stub.plantData[0], store: MockStore()))
//}
