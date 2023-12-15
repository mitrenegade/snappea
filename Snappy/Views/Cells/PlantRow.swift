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

    init(viewModel: PlantRowViewModel) {
        self.plantRowViewModel = viewModel
    }

    var body: some View {
        HStack {
            if let url = $plantRowViewModel.url.wrappedValue {
                AsyncImageView(url: url,
                               frame: CGSize(width: 80, height: 80),
                               placeholder: Image(systemName: "tree.fill"),
                               cache: TemporaryImageCache.shared)
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

#Preview {
    PlantRow(viewModel: PlantRowViewModel(plant: Stub.plantData[0], dataStore: MockDataStore()))
}

//struct PlantRow_Previews: PreviewProvider {
//    static var previews: some View {
//        PlantRow(plant: Stub.plantData[0])
//    }
//}
